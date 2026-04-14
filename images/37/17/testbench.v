`timescale 1ns/1ps

module tcp_segmenter_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data_in;
    reg valid_in;
    wire [7:0] segment_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tcp_segmenter dut (
        .data_in(data_in),
        .valid_in(valid_in),
        .segment_out(segment_out),
        .valid_out(valid_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Valid data input - Basic pattern", test_num);
        data_in = 32'h12345678;
        valid_in = 1'b1;

        #1;


        check_outputs(8'h12, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Valid data input - Hex pattern AA-DD", test_num);
        data_in = 32'hAABBCCDD;
        valid_in = 1'b1;
        #1;

        check_outputs(8'hAA, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input valid_in is low", test_num);
        data_in = 32'hDEADC0DE;
        valid_in = 1'b0;

        #1;


        check_outputs(8'h00, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary condition - All ones", test_num);
        data_in = 32'hFFFFFFFF;
        valid_in = 1'b1;
        #1;

        check_outputs(8'hFF, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary condition - All zeros", test_num);
        data_in = 32'h00000000;
        valid_in = 1'b1;
        #1;

        check_outputs(8'h00, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating bit pattern", test_num);
        data_in = 32'h5A5A5A5A;
        valid_in = 1'b1;
        #1;

        check_outputs(8'h5A, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Walking bit pattern", test_num);
        data_in = 32'h80402010;
        valid_in = 1'b1;
        #1;

        check_outputs(8'h80, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Data with lower bytes set", test_num);
        data_in = 32'h000000FF;
        valid_in = 1'b1;
        #1;

        check_outputs(8'h00, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("tcp_segmenter Testbench");
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
        input [7:0] expected_segment_out;
        input expected_valid_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_segment_out === (expected_segment_out ^ segment_out ^ expected_segment_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: segment_out=%h, valid_out=%b",
                         segment_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: segment_out=%h, valid_out=%b",
                         expected_segment_out, expected_valid_out);
                $display("  Got:      segment_out=%h, valid_out=%b",
                         segment_out, valid_out);
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
