`timescale 1ns/1ps

module OddParityGenerator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data_in;
    wire parity_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    OddParityGenerator dut (
        .data_in(data_in),
        .parity_out(parity_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Data = 0000 (0 ones)", test_num);
        data_in = 4'b0000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Data = 0001 (1 one)", test_num);
        data_in = 4'b0001;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Data = 0010 (1 one)", test_num);
        data_in = 4'b0010;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Data = 0011 (2 ones)", test_num);
        data_in = 4'b0011;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Data = 0100 (1 one)", test_num);
        data_in = 4'b0100;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Data = 0101 (2 ones)", test_num);
        data_in = 4'b0101;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Data = 0110 (2 ones)", test_num);
        data_in = 4'b0110;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Data = 0111 (3 ones)", test_num);
        data_in = 4'b0111;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Data = 1000 (1 one)", test_num);
        data_in = 4'b1000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Data = 1001 (2 ones)", test_num);
        data_in = 4'b1001;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Test Case %0d: Data = 1010 (2 ones)", test_num);
        data_in = 4'b1010;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Test Case %0d: Data = 1011 (3 ones)", test_num);
        data_in = 4'b1011;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        $display("Test Case %0d: Data = 1100 (2 ones)", test_num);
        data_in = 4'b1100;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        $display("Test Case %0d: Data = 1101 (3 ones)", test_num);
        data_in = 4'b1101;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        $display("Test Case %0d: Data = 1110 (3 ones)", test_num);
        data_in = 4'b1110;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        $display("Test Case %0d: Data = 1111 (4 ones)", test_num);
        data_in = 4'b1111;
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
        $display("OddParityGenerator Testbench");
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
        input expected_parity_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_parity_out === (expected_parity_out ^ parity_out ^ expected_parity_out)) begin
                $display("PASS");
                $display("  Outputs: parity_out=%b",
                         parity_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parity_out=%b",
                         expected_parity_out);
                $display("  Got:      parity_out=%b",
                         parity_out);
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
