`timescale 1ns/1ps

module crc32_generator_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data_in;
    wire [31:0] crc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    crc32_generator dut (
        .data_in(data_in),
        .crc_out(crc_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: All Zeros Input", test_num);
        data_in = 32'h00000000;

        #1;


        check_outputs(32'h2144DF1C);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: All Ones Input", test_num);
        data_in = 32'hFFFFFFFF;

        #1;


        check_outputs(32'hFF434A51);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Incremental Pattern", test_num);
        data_in = 32'h12345678;

        #1;


        check_outputs(32'h9400270D);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Hex Pattern (DEADBEEF)", test_num);
        data_in = 32'hDEADBEEF;

        #1;


        check_outputs(32'h14040A5D);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Alternating Bits", test_num);
        data_in = 32'h5555AAAA;

        #1;


        check_outputs(32'hC2634354);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Single Bit Set", test_num);
        data_in = 32'h80000000;

        #1;


        check_outputs(32'hED82CD11);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("crc32_generator Testbench");
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
        input [31:0] expected_crc_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_crc_out === (expected_crc_out ^ crc_out ^ expected_crc_out)) begin
                $display("PASS");
                $display("  Outputs: crc_out=%h",
                         crc_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crc_out=%h",
                         expected_crc_out);
                $display("  Got:      crc_out=%h",
                         crc_out);
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
