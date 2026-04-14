`timescale 1ns/1ps

module left_rotator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] D;
    wire [3:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    left_rotator dut (
        .D(D),
        .C(C)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: All Zeros (0000 -> 0000)", test_num);
        D = 4'b0000;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: All Ones (1111 -> 1111)", test_num);
        D = 4'b1111;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: MSB High (1000 -> 0001)", test_num);
        D = 4'b1000;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: LSB High (0001 -> 0010)", test_num);
        D = 4'b0001;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Alternating A (1010 -> 0101)", test_num);
        D = 4'b1010;
        #1;

        check_outputs(4'b0101);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Alternating B (0101 -> 1010)", test_num);
        D = 4'b0101;
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Middle Bits (0110 -> 1100)", test_num);
        D = 4'b0110;
        #1;

        check_outputs(4'b1100);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Complex Pattern (1011 -> 0111)", test_num);
        D = 4'b1011;
        #1;

        check_outputs(4'b0111);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("left_rotator Testbench");
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
        input [3:0] expected_C;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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
