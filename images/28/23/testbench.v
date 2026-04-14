`timescale 1ns/1ps

module priority_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] I;
    wire [2:0] O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder dut (
        .I(I),
        .O(O)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: All inputs inactive", test_num);
        I = 8'b0000_0000;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Only I7 active", test_num);
        I = 8'b1000_0000;
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Only I0 active", test_num);
        I = 8'b0000_0001;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Only I4 active", test_num);
        I = 8'b0001_0000;
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Priority check - I7 and I0 active", test_num);
        I = 8'b1000_0001;
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Priority check - I3, I2, I1 active", test_num);
        I = 8'b0000_1110;
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: All inputs active", test_num);
        I = 8'b1111_1111;
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Priority check - I6 and I2 active", test_num);
        I = 8'b0100_0100;
        #1;

        check_outputs(3'b110);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("priority_encoder Testbench");
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
        input [2:0] expected_O;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_O === (expected_O ^ O ^ expected_O)) begin
                $display("PASS");
                $display("  Outputs: O=%h",
                         O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O=%h",
                         expected_O);
                $display("  Got:      O=%h",
                         O);
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
