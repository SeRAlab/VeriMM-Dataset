`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg req1;
    reg req2;
    reg reset;
    wire ack1;
    wire ack2;
    wire [7:0] data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .req1(req1),
        .req2(req2),
        .reset(reset),
        .ack1(ack1),
        .ack2(ack2),
        .data(data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            req1 = 0;
            req2 = 0;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Idle State (No Requests)", test_num);
            reset_dut();


            #2;
            #1;

            check_outputs(1'b0, 1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Channel 1 Single Request", test_num);
            reset_dut();

            @(posedge clk);
            req1 = 1;


            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0, 8'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Channel 2 Single Request", test_num);
            reset_dut();

            @(posedge clk);
            req2 = 1;


            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b1, 8'h02);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Priority Check (Both Requests Active)", test_num);
            reset_dut();

            @(posedge clk);
            req1 = 1;
            req2 = 1;


            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0, 8'h01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Handover (Ch1 finished, Ch2 pending)", test_num);
            reset_dut();


            @(posedge clk);
            req1 = 1;
            req2 = 1;
            @(posedge clk);


            #1;
            req1 = 0;


            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b1, 8'h02);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Priority Re-assertion", test_num);
            reset_dut();


            @(posedge clk);
            req2 = 1;
            @(posedge clk);


            #1;
            req1 = 1;
            @(posedge clk);


            #1;
            req2 = 0;


            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0, 8'h01);
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
        input expected_ack1;
        input expected_ack2;
        input [7:0] expected_data;
        begin
            if (expected_ack1 === (expected_ack1 ^ ack1 ^ expected_ack1) &&
                expected_ack2 === (expected_ack2 ^ ack2 ^ expected_ack2) &&
                expected_data === (expected_data ^ data ^ expected_data)) begin
                $display("PASS");
                $display("  Outputs: ack1=%b, ack2=%b, data=%h",
                         ack1, ack2, data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack1=%b, ack2=%b, data=%h",
                         expected_ack1, expected_ack2, expected_data);
                $display("  Got:      ack1=%b, ack2=%b, data=%h",
                         ack1, ack2, data);
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
        $dumpvars(0,clk, req1, req2, reset, ack1, ack2, data);
    end

endmodule
