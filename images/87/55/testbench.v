`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_ack;
    reg [47:0] sample;
    reg sample_rdy;
    wire [7:0] data;
    wire data_rdy;
    wire sample_req;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_ack(data_ack),
        .sample(sample),
        .sample_rdy(sample_rdy),
        .data(data),
        .data_rdy(data_rdy),
        .sample_req(sample_req)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            sample = 48'h0;
            sample_rdy = 0;
            data_ack = 0;

            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Normal 48-bit transmission (0x0123456789AB)", test_num);
            reset_dut();

            sample = 48'h0123456789AB;
            sample_rdy = 1;


            wait(sample_req == 1);
            @(posedge clk);
            sample_rdy = 0;


            repeat(5) begin
                wait(data_rdy == 1);
                @(posedge clk);
                #1 data_ack = 1;
                @(posedge clk);
                #1 data_ack = 0;
            end


            wait(data_rdy == 1);
            #2;


            #1;



            check_outputs(8'hAB, 1'b1, 1'b0);


            @(posedge clk);
            data_ack = 1;
            @(posedge clk);
            data_ack = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Alternate pattern transmission (0xFEDCBA987654)", test_num);
            reset_dut();

            sample = 48'hFEDCBA987654;
            sample_rdy = 1;

            wait(sample_req == 1);
            @(posedge clk);
            sample_rdy = 0;

            repeat(5) begin
                wait(data_rdy == 1);
                @(posedge clk);
                #1 data_ack = 1;
                @(posedge clk);
                #1 data_ack = 0;
            end

            wait(data_rdy == 1);
            #2;


            #1;



            check_outputs(8'h54, 1'b1, 1'b0);

            @(posedge clk);
            data_ack = 1;
            @(posedge clk);
            data_ack = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Slow data_ack response", test_num);
            reset_dut();

            sample = 48'hAAAA_BBBB_CCCC;
            sample_rdy = 1;

            wait(sample_req == 1);
            @(posedge clk);
            sample_rdy = 0;


            repeat(5) begin
                wait(data_rdy == 1);
                repeat(5) @(posedge clk);
                #1 data_ack = 1;
                @(posedge clk);
                #1 data_ack = 0;
            end

            wait(data_rdy == 1);
            #2;


            #1;



            check_outputs(8'hCC, 1'b1, 1'b0);

            @(posedge clk);
            data_ack = 1;
            @(posedge clk);
            data_ack = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Verify return to IDLE", test_num);
            reset_dut();


            sample = 48'h112233445566;
            sample_rdy = 1;
            wait(sample_req == 1);
            @(posedge clk) sample_rdy = 0;
            repeat(6) begin
                wait(data_rdy == 1);
                @(posedge clk) #1 data_ack = 1;
                @(posedge clk) #1 data_ack = 0;
            end


            repeat(2) @(posedge clk);



            #1;




            check_outputs(data, 1'b0, 1'b0);
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
        input [7:0] expected_data;
        input expected_data_rdy;
        input expected_sample_req;
        begin
            if (expected_data === (expected_data ^ data ^ expected_data) &&
                expected_data_rdy === (expected_data_rdy ^ data_rdy ^ expected_data_rdy) &&
                expected_sample_req === (expected_sample_req ^ sample_req ^ expected_sample_req)) begin
                $display("PASS");
                $display("  Outputs: data=%h, data_rdy=%b, sample_req=%b",
                         data, data_rdy, sample_req);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h, data_rdy=%b, sample_req=%b",
                         expected_data, expected_data_rdy, expected_sample_req);
                $display("  Got:      data=%h, data_rdy=%b, sample_req=%b",
                         data, data_rdy, sample_req);
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
        $dumpvars(0,clk, data_ack, sample, sample_rdy, data, data_rdy, sample_req);
    end

endmodule
