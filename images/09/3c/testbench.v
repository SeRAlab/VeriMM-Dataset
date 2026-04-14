`timescale 1ns/1ps

module huffman_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in_char;
    wire [7:0] out_code;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    huffman_encoder dut (
        .in_char(in_char),
        .out_code(out_code)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Encoding 'A'...", test_num);
        in_char = 8'h41;
        #1;

        check_outputs(8'h0C);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Encoding 'B'...", test_num);
        in_char = 8'h42;
        #1;

        check_outputs(8'h0D);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Encoding 'C'...", test_num);
        in_char = 8'h43;
        #1;

        check_outputs(8'h04);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Encoding 'D'...", test_num);
        in_char = 8'h44;
        #1;

        check_outputs(8'h05);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Encoding 'E'...", test_num);
        in_char = 8'h45;
        #1;

        check_outputs(8'h07);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Encoding 'F'...", test_num);
        in_char = 8'h46;
        #1;

        check_outputs(8'h00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("huffman_encoder Testbench");
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
        input [7:0] expected_out_code;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_code === (expected_out_code ^ out_code ^ expected_out_code)) begin
                $display("PASS");
                $display("  Outputs: out_code=%h",
                         out_code);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_code=%h",
                         expected_out_code);
                $display("  Got:      out_code=%h",
                         out_code);
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
