`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [17:0] input_port;
    wire [9:0] output_port;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_port(input_port),
        .output_port(output_port)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: All zeros", test_num);
        input_port = 18'h00000;
        #1;

        check_outputs(10'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: All ones", test_num);
        input_port = 18'h3FFFF;
        #1;

        check_outputs(10'h3FF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Alternating pattern A", test_num);


        input_port = 18'h2AAAA;
        #1;

        check_outputs(10'h155);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Alternating pattern B", test_num);


        input_port = 18'h15555;
        #1;

        check_outputs(10'h2AA);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Boundary check - Only bit 12 set", test_num);

        input_port = 18'h01000;
        #1;

        check_outputs(10'h200);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Boundary check - Only bit 3 set", test_num);

        input_port = 18'h00008;
        #1;

        check_outputs(10'h001);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Out-of-bounds check (Upper bits)", test_num);

        input_port = 18'h3E000;
        #1;

        check_outputs(10'h000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Out-of-bounds check (Lower bits)", test_num);

        input_port = 18'h00007;
        #1;

        check_outputs(10'h000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Walking one", test_num);


        input_port = 18'h00080;
        #1;

        check_outputs(10'h010);
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
        input [9:0] expected_output_port;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_port === (expected_output_port ^ output_port ^ expected_output_port)) begin
                $display("PASS");
                $display("  Outputs: output_port=%h",
                         output_port);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_port=%h",
                         expected_output_port);
                $display("  Got:      output_port=%h",
                         output_port);
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
