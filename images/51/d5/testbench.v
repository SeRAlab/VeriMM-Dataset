`timescale 1ns/1ps

module priority_encoder_3bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] d;
    wire [2:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder_3bit dut (
        .d(d),
        .y(y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: No inputs high", test_num);
        d = 8'b0000_0000;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Only d0 high", test_num);
        d = 8'b0000_0001;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Only d1 high", test_num);
        d = 8'b0000_0010;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Only d2 high", test_num);
        d = 8'b0000_0100;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Only d3 high", test_num);
        d = 8'b0000_1000;
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Only d4 high", test_num);
        d = 8'b0001_0000;
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Only d5 high", test_num);
        d = 8'b0010_0000;
        #1;

        check_outputs(3'b101);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Only d6 high", test_num);
        d = 8'b0100_0000;
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Only d7 high", test_num);
        d = 8'b1000_0000;
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Multiple inputs (d7 and d0)", test_num);
        d = 8'b1000_0001;
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Multiple inputs (d4, d2, d1)", test_num);
        d = 8'b0001_0110;
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All inputs high", test_num);
        d = 8'b1111_1111;
        #1;

        check_outputs(3'b111);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("priority_encoder_3bit Testbench");
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
        input [2:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
