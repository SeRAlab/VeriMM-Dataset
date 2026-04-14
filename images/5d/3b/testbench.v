`timescale 1ns/1ps

module mux_2to1_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] IN0;
    reg [3:0] IN1;
    reg SEL;
    wire [3:0] OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_2to1 dut (
        .IN0(IN0),
        .IN1(IN1),
        .SEL(SEL),
        .OUT(OUT)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select IN0 (IN0=4'hA, IN1=4'h5, SEL=0)", test_num);
            IN0 = 4'hA;
            IN1 = 4'h5;
            SEL = 1'b0;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select IN1 (IN0=4'hA, IN1=4'h5, SEL=1)", test_num);
            IN0 = 4'hA;
            IN1 = 4'h5;
            SEL = 1'b1;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select IN0 All Zeros (IN0=4'h0, IN1=4'hF, SEL=0)", test_num);
            IN0 = 4'h0;
            IN1 = 4'hF;
            SEL = 1'b0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select IN1 All Ones (IN0=4'h0, IN1=4'hF, SEL=1)", test_num);
            IN0 = 4'h0;
            IN1 = 4'hF;
            SEL = 1'b1;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select IN0 with complex pattern (IN0=4'b1010, IN1=4'b1100, SEL=0)", test_num);
            IN0 = 4'b1010;
            IN1 = 4'b1100;
            SEL = 1'b0;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select IN1 with complex pattern (IN0=4'b1010, IN1=4'b1100, SEL=1)", test_num);
            IN0 = 4'b1010;
            IN1 = 4'b1100;
            SEL = 1'b1;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_2to1 Testbench");
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
        input [3:0] expected_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OUT === (expected_OUT ^ OUT ^ expected_OUT)) begin
                $display("PASS");
                $display("  Outputs: OUT=%h",
                         OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT=%h",
                         expected_OUT);
                $display("  Got:      OUT=%h",
                         OUT);
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
