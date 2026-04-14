`timescale 1ns/1ps

module qam_modulator_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] I;
    reg [1:0] Q;
    wire [3:0] symbol;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    qam_modulator dut (
        .I(I),
        .Q(Q),
        .symbol(symbol)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input I=00, Q=00", test_num);
            I = 2'b00;
            Q = 2'b00;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input I=01, Q=01", test_num);
            I = 2'b01;
            Q = 2'b01;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input I=10, Q=10", test_num);
            I = 2'b10;
            Q = 2'b10;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input I=11, Q=11", test_num);
            I = 2'b11;
            Q = 2'b11;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input I=01, Q=10", test_num);
            I = 2'b01;
            Q = 2'b10;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input I=11, Q=00", test_num);
            I = 2'b11;
            Q = 2'b00;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input I=00, Q=11", test_num);
            I = 2'b00;
            Q = 2'b11;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input I=10, Q=01", test_num);
            I = 2'b10;
            Q = 2'b01;
            #1;

            check_outputs(4'b1001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("qam_modulator Testbench");
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
        input [3:0] expected_symbol;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_symbol === (expected_symbol ^ symbol ^ expected_symbol)) begin
                $display("PASS");
                $display("  Outputs: symbol=%h",
                         symbol);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: symbol=%h",
                         expected_symbol);
                $display("  Got:      symbol=%h",
                         symbol);
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
