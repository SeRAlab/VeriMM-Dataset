`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg REQ0;
    reg REQ1;
    reg START;
    reg clk;
    reg rst_n;
    wire [7:0] DATA;
    wire GNT0;
    wire GNT1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .REQ0(REQ0),
        .REQ1(REQ1),
        .START(START),
        .clk(clk),
        .rst_n(rst_n),
        .DATA(DATA),
        .GNT0(GNT0),
        .GNT1(GNT1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            REQ0 = 0;
            REQ1 = 0;
            START = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Idle State (No Requests)", test_num);
            reset_dut();

            REQ0 = 0;
            REQ1 = 0;
            START = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Channel 0 Request", test_num);
            reset_dut();
            REQ0 = 1;
            REQ1 = 0;
            START = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Channel 1 Request", test_num);
            reset_dut();
            REQ0 = 0;
            REQ1 = 1;
            START = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Priority Check (Both REQ0 and REQ1 high)", test_num);
            reset_dut();
            REQ0 = 1;
            REQ1 = 1;
            START = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Data Transfer for Channel 0 (START=1)", test_num);
            reset_dut();
            REQ0 = 1;
            REQ1 = 0;
            START = 1;
            @(posedge clk);
            #2;


            #1;



            check_outputs(DATA, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Data Transfer for Channel 1 (START=1)", test_num);
            reset_dut();
            REQ0 = 0;
            REQ1 = 1;
            START = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(DATA, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Dynamic Priority Shift (REQ1 active, then REQ0 arrives)", test_num);
            reset_dut();

            REQ0 = 0;
            REQ1 = 1;
            @(posedge clk);
            #2;
            if (GNT1 !== 1'b1) $display("Intermediate check failed: GNT1 not active");


            REQ0 = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(DATA, 1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Release of Requests", test_num);
            reset_dut();
            REQ0 = 1;
            @(posedge clk);
            #2;

            REQ0 = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00, 1'b0, 1'b0);
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
        testcase008();
        
        
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
        input [7:0] expected_DATA;
        input expected_GNT0;
        input expected_GNT1;
        begin
            if (expected_DATA === (expected_DATA ^ DATA ^ expected_DATA) &&
                expected_GNT0 === (expected_GNT0 ^ GNT0 ^ expected_GNT0) &&
                expected_GNT1 === (expected_GNT1 ^ GNT1 ^ expected_GNT1)) begin
                $display("PASS");
                $display("  Outputs: DATA=%h, GNT0=%b, GNT1=%b",
                         DATA, GNT0, GNT1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DATA=%h, GNT0=%b, GNT1=%b",
                         expected_DATA, expected_GNT0, expected_GNT1);
                $display("  Got:      DATA=%h, GNT0=%b, GNT1=%b",
                         DATA, GNT0, GNT1);
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
        $dumpvars(0,REQ0, REQ1, START, clk, rst_n, DATA, GNT0, GNT1);
    end

endmodule
