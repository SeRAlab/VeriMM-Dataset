`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] FLAG;
    reg Negative;
    reg Overflow;
    reg Zero;
    wire S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .FLAG(FLAG),
        .Negative(Negative),
        .Overflow(Overflow),
        .Zero(Zero),
        .S(S)
    );
    task testcase001;

    begin
        test_num = 1;
        FLAG = 3'b000; Zero = 1; Negative = 0; Overflow = 0;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        FLAG = 3'b000; Zero = 0; Negative = 1; Overflow = 0;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        FLAG = 3'b001; Zero = 0; Negative = 0; Overflow = 0;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        FLAG = 3'b001; Zero = 1; Negative = 0; Overflow = 0;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        FLAG = 3'b010; Zero = 0; Negative = 1; Overflow = 0;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        FLAG = 3'b010; Zero = 0; Negative = 1; Overflow = 1;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        FLAG = 3'b011; Zero = 1; Negative = 0; Overflow = 0;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        FLAG = 3'b011; Zero = 0; Negative = 1; Overflow = 0;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        FLAG = 3'b011; Zero = 0; Negative = 0; Overflow = 0;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        FLAG = 3'b100; Zero = 0; Negative = 0; Overflow = 0;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        FLAG = 3'b100; Zero = 0; Negative = 1; Overflow = 0;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        FLAG = 3'b101; Zero = 0; Negative = 0; Overflow = 0;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        FLAG = 3'b101; Zero = 1; Negative = 0; Overflow = 0;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        FLAG = 3'b101; Zero = 0; Negative = 1; Overflow = 0;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        FLAG = 3'b110; Zero = 1; Negative = 1; Overflow = 1;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        FLAG = 3'b111; Zero = 1; Negative = 1; Overflow = 1;
        #10;
        #1;

        check_outputs(1'b0);
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
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: S=%b",
                         S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%b",
                         expected_S);
                $display("  Got:      S=%b",
                         S);
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
