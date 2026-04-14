`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in_channel_1;
    reg [7:0] data_in_channel_2;
    reg request_channel_1;
    reg request_channel_2;
    reg reset;
    wire [7:0] data_out_channel_1;
    wire [7:0] data_out_channel_2;
    wire grant_channel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .data_in_channel_1(data_in_channel_1),
        .data_in_channel_2(data_in_channel_2),
        .request_channel_1(request_channel_1),
        .request_channel_2(request_channel_2),
        .reset(reset),
        .data_out_channel_1(data_out_channel_1),
        .data_out_channel_2(data_out_channel_2),
        .grant_channel(grant_channel)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            request_channel_1 = 0;
            request_channel_2 = 0;
            data_in_channel_1 = 8'h0;
            data_in_channel_2 = 8'h0;
            #10;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Idle State (No Requests)", test_num);
            reset_dut();


            request_channel_1 = 0;
            request_channel_2 = 0;

            @(posedge clk);
            #1;



            #1;




            check_outputs(8'h00, 8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Channel 1 Single Request", test_num);
            reset_dut();

            request_channel_1 = 1;
            request_channel_2 = 0;
            data_in_channel_1 = 8'hAA;

            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hAA, 8'h00, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Channel 2 Single Request", test_num);
            reset_dut();

            request_channel_1 = 0;
            request_channel_2 = 1;
            data_in_channel_2 = 8'hBB;

            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 8'hBB, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Concurrent Requests - Initial Priority (Ch 1)", test_num);
            reset_dut();

            request_channel_1 = 1;
            request_channel_2 = 1;
            data_in_channel_1 = 8'h11;
            data_in_channel_2 = 8'h22;

            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h11, 8'h00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Round Robin Alternation - Second Cycle (Ch 2)", test_num);
            reset_dut();

            request_channel_1 = 1;
            request_channel_2 = 1;
            data_in_channel_1 = 8'h11;
            data_in_channel_2 = 8'h22;

            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 8'h22, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Round Robin Wrap Around", test_num);
            reset_dut();

            request_channel_1 = 1;
            request_channel_2 = 1;
            data_in_channel_1 = 8'hCC;
            data_in_channel_2 = 8'hDD;

            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hCC, 8'h00, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Intermittent Requests", test_num);
            reset_dut();


            request_channel_1 = 1;
            data_in_channel_1 = 8'hA1;
            @(posedge clk);


            request_channel_1 = 0;
            request_channel_2 = 1;
            data_in_channel_2 = 8'hB2;
            @(posedge clk);

            #1;
            #1;

            check_outputs(8'h00, 8'hB2, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [7:0] expected_data_out_channel_1;
        input [7:0] expected_data_out_channel_2;
        input expected_grant_channel;
        begin
            if (expected_data_out_channel_1 === (expected_data_out_channel_1 ^ data_out_channel_1 ^ expected_data_out_channel_1) &&
                expected_data_out_channel_2 === (expected_data_out_channel_2 ^ data_out_channel_2 ^ expected_data_out_channel_2) &&
                expected_grant_channel === (expected_grant_channel ^ grant_channel ^ expected_grant_channel)) begin
                $display("PASS");
                $display("  Outputs: data_out_channel_1=%h, data_out_channel_2=%h, grant_channel=%b",
                         data_out_channel_1, data_out_channel_2, grant_channel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out_channel_1=%h, data_out_channel_2=%h, grant_channel=%b",
                         expected_data_out_channel_1, expected_data_out_channel_2, expected_grant_channel);
                $display("  Got:      data_out_channel_1=%h, data_out_channel_2=%h, grant_channel=%b",
                         data_out_channel_1, data_out_channel_2, grant_channel);
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
        $dumpvars(0,clk, data_in_channel_1, data_in_channel_2, request_channel_1, request_channel_2, reset, data_out_channel_1, data_out_channel_2, grant_channel);
    end

endmodule
