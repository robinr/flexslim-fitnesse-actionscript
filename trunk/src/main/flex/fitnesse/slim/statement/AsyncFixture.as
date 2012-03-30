package fitnesse.slim.statement {
    import flash.events.Event;
    import flash.events.EventDispatcher;
    
    [Event(name="done", type="flash.events.Event")]
    public class AsyncFixture extends EventDispatcher {
        public function done():void {
            dispatchEvent(new Event("done"));
        }
        
    }
}