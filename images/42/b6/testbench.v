`timescale 1ns/1ps

module decoder_4to16_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] binary;
    wire [15:0] one_hot;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder_4to16 dut (
        .binary(binary),
        .one_hot(one_hot)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 1: Input binary = 4'h0");
        binary = 4'h0;
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 2: Input binary = 4'h1");
        binary = 4'h1;
        #1;

        check_outputs(16'h0002);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 3: Input binary = 4'h2");
        binary = 4'h2;
        #1;

        check_outputs(16'h0004);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 4: Input binary = 4'h3");
        binary = 4'h3;
        #1;

        check_outputs(16'h0008);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 5: Input binary = 4'h4");
        binary = 4'h4;
        #1;

        check_outputs(16'h0010);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 6: Input binary = 4'h5");
        binary = 4'h5;
        #1;

        check_outputs(16'h0020);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 7: Input binary = 4'h6");
        binary = 4'h6;
        #1;

        check_outputs(16'h0040);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 8: Input binary = 4'h7");
        binary = 4'h7;
        #1;

        check_outputs(16'h0080);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case 9: Input binary = 4'h8");
        binary = 4'h8;
        #1;

        check_outputs(16'h0100);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case 10: Input binary = 4'h9");
        binary = 4'h9;
        #1;

        check_outputs(16'h0200);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Test Case 11: Input binary = 4'hA");
        binary = 4'hA;
        #1;

        check_outputs(16'h0400);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Test Case 12: Input binary = 4'hB");
        binary = 4'hB;
        #1;

        check_outputs(16'h0800);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        $display("Test Case 13: Input binary = 4'hC");
        binary = 4'hC;
        #1;

        check_outputs(16'h1000);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        $display("Test Case 14: Input binary = 4'hD");
        binary = 4'hD;
        #1;

        check_outputs(16'h2000);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        $display("Test Case 15: Input binary = 4'hE");
        binary = 4'hE;
        #1;

        check_outputs(16'h4000);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        $display("Test Case 16: Input binary = 4'hF");
        binary = 4'hF;
        #1;

        check_outputs(16'h8000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decoder_4to16 Testbench");
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
        input [15:0] expected_one_hot;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_one_hot === (expected_one_hot ^ one_hot ^ expected_one_hot)) begin
                $display("PASS");
                $display("  Outputs: one_hot=%h",
                         one_hot);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: one_hot=%h",
                         expected_one_hot);
                $display("  Got:      one_hot=%h",
                         one_hot);
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
