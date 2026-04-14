`timescale 1ns/1ps

module binary_to_gray_converter_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] binary_in;
    reg clk;
    wire [3:0] gray_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_to_gray_converter dut (
        .binary_in(binary_in),
        .clk(clk),
        .gray_out(gray_out)
    );
    task initialize;

    begin
        binary_in = 4'b0000;
        @(posedge clk);
        #1;
    end
        endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: binary_in = 0000");
        initialize();
        binary_in = 4'b0000;
        @(posedge clk);
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: binary_in = 0001");
        initialize();
        binary_in = 4'b0001;
        @(posedge clk);
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: binary_in = 0010");
        initialize();
        binary_in = 4'b0010;
        @(posedge clk);
        #1;

        check_outputs(4'b0011);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: binary_in = 0100");
        initialize();
        binary_in = 4'b0100;
        @(posedge clk);
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: binary_in = 1000");
        initialize();
        binary_in = 4'b1000;
        @(posedge clk);
        #1;

        check_outputs(4'b1100);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case 006: binary_in = 1111");
        initialize();
        binary_in = 4'b1111;
        @(posedge clk);
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case 007: binary_in = 1010");
        initialize();
        binary_in = 4'b1010;
        @(posedge clk);
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case 008: binary_in = 0111");
        initialize();
        binary_in = 4'b0111;
        @(posedge clk);
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case 009: binary_in = 1101");
        initialize();
        binary_in = 4'b1101;
        @(posedge clk);
        #1;

        check_outputs(4'b1011);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case 010: binary_in = 0110");
        initialize();
        binary_in = 4'b0110;
        @(posedge clk);
        #1;

        check_outputs(4'b0101);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_to_gray_converter Testbench");
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
        input [3:0] expected_gray_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_gray_out === (expected_gray_out ^ gray_out ^ expected_gray_out)) begin
                $display("PASS");
                $display("  Outputs: gray_out=%h",
                         gray_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gray_out=%h",
                         expected_gray_out);
                $display("  Got:      gray_out=%h",
                         gray_out);
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
