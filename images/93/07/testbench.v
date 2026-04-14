`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ctrl;
    reg [3:0] p;
    reg [3:0] q;
    wire [3:0] r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl(ctrl),
        .p(p),
        .q(q),
        .r(r)
    );
    task testcase001;

        begin
            test_num = 1;
            ctrl = 2'b00; p = 4'b1010; q = 4'b0101;
            $display("Test %0d: OR operation (ctrl=0) - 1010 | 0101", test_num);
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            ctrl = 2'b00; p = 4'b0000; q = 4'b0000;
            $display("Test %0d: OR operation (ctrl=0) - 0000 | 0000", test_num);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            ctrl = 2'b00; p = 4'b1111; q = 4'b0110;
            $display("Test %0d: OR operation (ctrl=0) - 1111 | 0110", test_num);
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            ctrl = 2'b01; p = 4'b1010; q = 4'b1100;
            $display("Test %0d: AND operation (ctrl=1) - 1010 & 1100", test_num);
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            ctrl = 2'b01; p = 4'b1111; q = 4'b1111;
            $display("Test %0d: AND operation (ctrl=1) - 1111 & 1111", test_num);
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            ctrl = 2'b01; p = 4'b1010; q = 4'b0101;
            $display("Test %0d: AND operation (ctrl=1) - 1010 & 0101", test_num);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            ctrl = 2'b10; p = 4'b1100; q = 4'b1010;
            $display("Test %0d: XOR operation (ctrl=2) - 1100 ^ 1010", test_num);
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            ctrl = 2'b10; p = 4'b1111; q = 4'b1111;
            $display("Test %0d: XOR operation (ctrl=2) - 1111 ^ 1111", test_num);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            ctrl = 2'b10; p = 4'b1111; q = 4'b0000;
            $display("Test %0d: XOR operation (ctrl=2) - 1111 ^ 0000", test_num);
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            ctrl = 2'b00; p = 4'h3; q = 4'hC;
            $display("Test %0d: OR operation (ctrl=0) - 3 | C", test_num);
            #1;

            check_outputs(4'hF);
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
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [3:0] expected_r;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_r === (expected_r ^ r ^ expected_r)) begin
                $display("PASS");
                $display("  Outputs: r=%h",
                         r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r=%h",
                         expected_r);
                $display("  Got:      r=%h",
                         r);
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

endmodule
