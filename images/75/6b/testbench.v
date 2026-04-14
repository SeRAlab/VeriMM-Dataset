`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg enable;
    reg pause;
    reg req_aclk;
    reg req_aresetn;
    reg [16:0] req_burst_count;
    reg req_valid;
    reg [2:0] response_id;
    wire eot;
    wire req_ready;
    wire [2:0] request_id;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .enable(enable),
        .pause(pause),
        .req_aclk(req_aclk),
        .req_aresetn(req_aresetn),
        .req_burst_count(req_burst_count),
        .req_valid(req_valid),
        .response_id(response_id),
        .eot(eot),
        .req_ready(req_ready),
        .request_id(request_id)
    );

    // Clock generation (10ns period)
    initial begin
        req_aclk = 0;
        forever #5 req_aclk = ~req_aclk;
    end

        task reset_dut;

        begin
            req_aresetn = 0;
            enable = 0;
            pause = 0;
            req_valid = 0;
            req_burst_count = 0;
            response_id = 3'b000;
            repeat(5) @(posedge req_aclk);
            req_aresetn = 1;
            repeat(2) @(posedge req_aclk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            enable = 1;
            pause = 0;
            @(posedge req_aclk);
            req_burst_count = 17'd1;
            req_valid = 1;


            wait(req_ready == 1);
            @(posedge req_aclk);
            req_valid = 0;


            response_id = request_id;
            @(posedge req_aclk);



            #1;




            check_outputs(1'b1, 1'b1, 3'h1);
        end
        endtask

    task testcase002;

        integer i;
        reg [2:0] current_id;
        begin
            reset_dut();
            enable = 1;
            pause = 0;
            @(posedge req_aclk);
            req_burst_count = 17'd3;
            req_valid = 1;

            wait(req_ready == 1);
            @(posedge req_aclk);
            req_valid = 0;
            current_id = request_id;


            for(i = 0; i < 3; i = i + 1) begin
                response_id = current_id;
                @(posedge req_aclk);
            end


            #1;



            check_outputs(1'b1, 1'b1, current_id);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            enable = 1;
            pause = 1;
            @(posedge req_aclk);


            req_valid = 1;
            req_burst_count = 17'd1;
            repeat(2) @(posedge req_aclk);


            pause = 0;
            wait(req_ready == 1);
            @(posedge req_aclk);
            req_valid = 0;
            response_id = request_id;
            @(posedge req_aclk);


            #1;



            check_outputs(1'b1, 1'b1, 3'h1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            enable = 0;
            pause = 0;
            @(posedge req_aclk);

            req_valid = 1;
            repeat(3) @(posedge req_aclk);



            #1;




            check_outputs(1'b0, 1'b0, 3'h0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            enable = 1;
            pause = 0;


            req_burst_count = 17'd1;
            req_valid = 1;
            wait(req_ready == 1);
            @(posedge req_aclk);
            req_valid = 0;
            response_id = request_id;
            @(posedge req_aclk);
            response_id = 3'b000;
            @(posedge req_aclk);


            req_valid = 1;
            wait(req_ready == 1);
            @(posedge req_aclk);
            req_valid = 0;
            response_id = request_id;
            @(posedge req_aclk);


            #1;



            check_outputs(1'b1, 1'b1, 3'h2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input expected_eot;
        input expected_req_ready;
        input [2:0] expected_request_id;
        begin
            if (expected_eot === (expected_eot ^ eot ^ expected_eot) &&
                expected_req_ready === (expected_req_ready ^ req_ready ^ expected_req_ready) &&
                expected_request_id === (expected_request_id ^ request_id ^ expected_request_id)) begin
                $display("PASS");
                $display("  Outputs: eot=%b, req_ready=%b, request_id=%h",
                         eot, req_ready, request_id);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: eot=%b, req_ready=%b, request_id=%h",
                         expected_eot, expected_req_ready, expected_request_id);
                $display("  Got:      eot=%b, req_ready=%b, request_id=%h",
                         eot, req_ready, request_id);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,enable, pause, req_aclk, req_aresetn, req_burst_count, req_valid, response_id, eot, req_ready, request_id);
    end

endmodule
