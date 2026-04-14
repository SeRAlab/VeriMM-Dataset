`timescale 1ns/1ps

module rs_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data;
    wire [47:0] codeword;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rs_encoder dut (
        .data(data),
        .codeword(codeword)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros Input", test_num);
        data = 32'h00000000;
        #1;

        check_outputs(48'h000000000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Unit LSB Byte", test_num);
        data = 32'h00000001;
        #1;

        check_outputs(48'h000000010302);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Unit Second Byte", test_num);
        data = 32'h00000100;
        #1;

        check_outputs(48'h000001000706);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Unit MSB Byte", test_num);
        data = 32'h01000000;
        #1;

        check_outputs(48'h01000000231E);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating Pattern", test_num);
        data = 32'h01020304;
        #1;

        check_outputs(48'h01020304192E);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rs_encoder Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [47:0] expected_codeword;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_codeword === (expected_codeword ^ codeword ^ expected_codeword)) begin
                $display("PASS");
                $display("  Outputs: codeword=%h",
                         codeword);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: codeword=%h",
                         expected_codeword);
                $display("  Got:      codeword=%h",
                         codeword);
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
