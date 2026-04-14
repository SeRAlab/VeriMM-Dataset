`timescale 1ns/1ps

module mux_2to1_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] IN0;
    reg [7:0] IN1;
    reg SEL;
    wire [7:0] OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_2to1_8bit dut (
        .IN0(IN0),
        .IN1(IN1),
        .SEL(SEL),
        .OUT(OUT)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: SEL=0 - Selecting IN0 with simple values", test_num);
            IN0 = 8'hA5;
            IN1 = 8'h5A;
            SEL = 1'b0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: SEL=1 - Selecting IN1 with simple values", test_num);
            IN0 = 8'hA5;
            IN1 = 8'h5A;
            SEL = 1'b1;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: SEL=0 - Boundary check (All Ones vs All Zeros)", test_num);
            IN0 = 8'hFF;
            IN1 = 8'h00;
            SEL = 1'b0;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: SEL=1 - Boundary check (All Ones vs All Zeros)", test_num);
            IN0 = 8'hFF;
            IN1 = 8'h00;
            SEL = 1'b1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: SEL=0 - Alternating bit patterns", test_num);
            IN0 = 8'hAA;
            IN1 = 8'h55;
            SEL = 1'b0;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: SEL=1 - Alternating bit patterns", test_num);
            IN0 = 8'hAA;
            IN1 = 8'h55;
            SEL = 1'b1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Verification when IN0 and IN1 are identical", test_num);
            IN0 = 8'h42;
            IN1 = 8'h42;
            SEL = 1'b0;
            #1;

            check_outputs(8'h42);
            SEL = 1'b1;
            #1;

            check_outputs(8'h42);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_2to1_8bit Testbench");
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
        input [7:0] expected_OUT;
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
