import GoogleGenerativeAI

class GeminiX {
    
    static var model: GenerativeModel?
    
    
    static func initModel(params:[String: Any]) {
        
        let modelName = params["modelName"] as? String ?? ""
        let apiKey = params["apiKey"] as? String ?? ""
        
        let temperature = params["temperature"] != nil ? params["temperature"] as? Float : nil
        let topK = params["topK"] != nil ? params["topK"] as? Int : nil
        let topP = params["topP"] != nil ? params["topP"] as? Float : nil
        let maxOutputTokens = params["maxOutputTokens"] != nil ? params["maxOutputTokens"] as? Int : nil
        let stopSequences = params["stopSequences"] != nil ? params["stopSequences"] as? [String] : nil
        
        let safetySettings = params["safetySettings"] != nil ? params["safetySettings"] as? [String: String] : nil

        
        // TODO safetySettings
        
        let generationConfig = GenerationConfig(
            temperature: temperature,
            topP: topP,
            topK: topK,
            maxOutputTokens: maxOutputTokens,
            stopSequences: stopSequences
        )
        
        self.model = GenerativeModel(name:modelName, apiKey:apiKey, generationConfig:generationConfig)
    }
    
    static func sendMessage(inputText:String, onSuccess:@escaping(String) -> Void, onError:@escaping(String) -> Void) {
        Task.detached(operation: {
            // TODO support images for multi-modal models
            
            do{
                let response = try await self.model?.generateContent(inputText)
                let result = (response?.text)!
                onSuccess(result)
            }catch{
                onError("\(error)")
            }
        })
        
    }

    static func countTokens(inputText:String, onSuccess:@escaping(String) -> Void, onError:@escaping(String) -> Void) {
        Task.detached(operation:{
            // TODO support images for multi-modal models
            
            do{
                let response = try await self.model?.countTokens(inputText)
                let result = (response?.totalTokens)!
                onSuccess("\(result)")
            }catch{
                onError("\(error)")
            }
        })
    }

}
