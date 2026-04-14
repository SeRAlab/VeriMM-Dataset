`timescale 1ns/1ps

module gray_decoder_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] gin;
    wire [5:0] bout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gray_decoder dut (
        .gin(gin),
        .bout(bout)
    );
    task testcase001;

    begin
        $display("Test Case 001: All Zeros");
        gin = 6'b000000;
        #1;

        check_outputs(6'b000000);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: LSB only");
        gin = 6'b000001;
        #1;

        check_outputs(6'b000001);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: Simple 2-bit Gray 11 to Binary 10");
        gin = 6'b000011;
        #1;

        check_outputs(6'b000010);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: Simple 2-bit Gray 10 to Binary 11");
        gin = 6'b000010;
        #1;

        check_outputs(6'b000011);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: Gray 000110 to Binary 000100");
        gin = 6'b000110;
        #1;

        check_outputs(6'b000100);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: MSB Set (Propagation Check)");
        gin = 6'b100000;
        #1;

        check_outputs(6'b111111);
    end
        endtask

    task testcase007;

    begin
        $display("Test Case 007: All Ones");
        gin = 6'b111111;
        #1;

        check_outputs(6'b101010);
    end
        endtask

    task testcase008;

    begin
        $display("Test Case 008: Alternating Bits Gray 101010");
        gin = 6'b101010;
        #1;

        check_outputs(6'b110011);
    end
        endtask

    task testcase009;

    begin
        $display("Test Case 009: Pattern 010101");
        gin = 6'b010101;
        #1;

        check_outputs(6'b011001);
    end
        endtask

    task testcase010;

    begin
        $display("Test Case 010: Pattern 110110");
        gin = 6'b110110;
        #1;

        check_outputs(6'b100100);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gray_decoder Testbench");
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
        input [5:0] expected_bout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bout === (expected_bout ^ bout ^ expected_bout)) begin
                $display("PASS");
                $display("  Outputs: bout=%h",
                         bout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bout=%h",
                         expected_bout);
                $display("  Got:      bout=%h",
                         bout);
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
