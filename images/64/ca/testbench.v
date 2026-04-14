`timescale 1ns/1ps

module adder_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] k;
    reg [5:0] l;
    wire [5:0] m;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder dut (
        .k(k),
        .l(l),
        .m(m)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            k = 6'd0;
            l = 6'd0;
            #1;

            check_outputs(6'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Addition", test_num);
            k = 6'd10;
            l = 6'd15;
            #1;

            check_outputs(6'd25);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum sum without overflow", test_num);
            k = 6'd31;
            l = 6'd32;
            #1;

            check_outputs(6'd63);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow case (63 + 1)", test_num);
            k = 6'd63;
            l = 6'd1;
            #1;

            check_outputs(6'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max overflow (63 + 63)", test_num);
            k = 6'd63;
            l = 6'd63;
            #1;

            check_outputs(6'd62);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits", test_num);
            k = 6'b101010;
            l = 6'b010101;
            #1;

            check_outputs(6'b111111);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identity property", test_num);
            k = 6'd45;
            l = 6'd0;
            #1;

            check_outputs(6'd45);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder Testbench");
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
        input [5:0] expected_m;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_m === (expected_m ^ m ^ expected_m)) begin
                $display("PASS");
                $display("  Outputs: m=%h",
                         m);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: m=%h",
                         expected_m);
                $display("  Got:      m=%h",
                         m);
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
