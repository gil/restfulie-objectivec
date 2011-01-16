/*
 * Request.m
 * restfulie-objectivec
 *
 * Created by Bruno Fuster on 10/22/10.
 * 
 * Copyright (c) 2009 Caelum - www.caelum.com.br/opensource
 * All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


#import "Request.h"
#import "Response.h"
#import "JSONUnmarshaller.h"
#import "JsonMediaType.h"
#import "ASIHTTPRequest.h"

@implementation Request
@synthesize uri, error, mediaType, client, request;

+(Request *) requestWithURI:(NSString *)uri andClient:(id<RestClient>)restClient
{
	
	Request *req = [[Request alloc] init];
	[req setUri:[NSURL URLWithString:uri]];	
	[req setMediaType:[restClient currentMediaType]];
	[req setClient:restClient];
	[req  setRequest:[ASIHTTPRequest requestWithURL:req.uri]];
	return req;
}


-(Request*) authUser:(NSString*)usr andPassword:(NSString*)password {

	[request setUseKeychainPersistence:YES];
	[request setUsername:usr];
	[request setPassword:password];
	
	return self;
}

-(Response *) get 
{
	
	[request startSynchronous];
	
	Response *response = [Response initWithData:[request responseString] andClient:self.client];
	[response setCode:[request responseStatusCode]];
	
	return response;
}

-(Response*) post {

	[request setRequestMethod:@"POST"];
	[request startSynchronous];
	
	Response *response = [Response initWithData:[request responseString] andClient:self.client];
	[response setCode:[request responseStatusCode]];
	
	return response;
	
}

-(Response*) post:(id)obj
{
	return nil;
}

-(void) dealloc {
	
	[uri release];
	[error release];
	[request release];
	[super dealloc];
}

@end
