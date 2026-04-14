`timescale 1ns/1ps

module fixed_priority_arbiter_tb;

    // Testbench signals (sequential circuit)
    reg R0;
    reg R1;
    reg R2;
    reg clk;
    reg rst;
    wire G0;
    wire G1;
    wire G2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fixed_priority_arbiter dut (
        .R0(R0),
        .R1(R1),
        .R2(R2),
        .clk(clk),
        .rst(rst),
        .G0(G0),
        .G1(G1),
        .G2(G2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            R0 = 0;
            R1 = 0;
            R2 = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: Reset State Check", test_num);
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            R0 = 1; R1 = 0; R2 = 0;
            @(posedge clk);
            #2;
            $display("Test %0d: Single request R0", test_num);
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            R0 = 0; R1 = 1; R2 = 0;
            @(posedge clk);
            #2;
            $display("Test %0d: Single request R1", test_num);
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            R0 = 0; R1 = 0; R2 = 1;
            @(posedge clk);
            #2;
            $display("Test %0d: Single request R2", test_num);
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            R0 = 1; R1 = 1; R2 = 0;
            @(posedge clk);
            #2;
            $display("Test %0d: Simultaneous R0 and R1", test_num);
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            R0 = 0; R1 = 1; R2 = 1;
            @(posedge clk);
            #2;
            $display("Test %0d: Simultaneous R1 and R2", test_num);
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            R0 = 1; R1 = 0; R2 = 1;
            @(posedge clk);
            #2;
            $display("Test %0d: Simultaneous R0 and R2", test_num);
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            R0 = 1; R1 = 1; R2 = 1;
            @(posedge clk);
            #2;
            $display("Test %0d: All requests R0, R1, R2", test_num);
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            R0 = 0; R1 = 0; R2 = 0;
            @(posedge clk);
            #2;
            $display("Test %0d: No requests", test_num);
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fixed_priority_arbiter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input expected_G0;
        input expected_G1;
        input expected_G2;
        begin
            if (expected_G0 === (expected_G0 ^ G0 ^ expected_G0) &&
                expected_G1 === (expected_G1 ^ G1 ^ expected_G1) &&
                expected_G2 === (expected_G2 ^ G2 ^ expected_G2)) begin
                $display("PASS");
                $display("  Outputs: G0=%b, G1=%b, G2=%b",
                         G0, G1, G2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: G0=%b, G1=%b, G2=%b",
                         expected_G0, expected_G1, expected_G2);
                $display("  Got:      G0=%b, G1=%b, G2=%b",
                         G0, G1, G2);
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
        $dumpvars(0,R0, R1, R2, clk, rst, G0, G1, G2);
    end

endmodule
