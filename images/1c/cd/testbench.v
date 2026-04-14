`timescale 1ns/1ps

module hamming_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in;
    wire [20:0] codeword_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hamming_encoder dut (
        .data_in(data_in),
        .codeword_out(codeword_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros", test_num);
        data_in = 16'h0000;
        #1;

        check_outputs(21'h000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Data Bit 0 set (D0=1)", test_num);
        data_in = 16'h0001;


        #1;



        check_outputs(21'h000007);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Data Bit 1 set (D1=1)", test_num);
        data_in = 16'h0002;


        #1;



        check_outputs(21'h000019);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Data Bit 2 set (D2=1)", test_num);
        data_in = 16'h0004;


        #1;



        check_outputs(21'h00002A);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Data Bit 15 set (D15=1)", test_num);
        data_in = 16'h8000;


        #1;



        check_outputs(21'h108009);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Ones", test_num);
        data_in = 16'hFFFF;


        #1;



        check_outputs(21'h1FFFFE);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating Bits 0xAAAA", test_num);
        data_in = 16'hAAAA;

        #1;


        check_outputs(21'h15AAED);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating Bits 0x5555", test_num);
        data_in = 16'h5555;

        #1;


        check_outputs(21'h0A5527);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Hex Pattern 0x1234", test_num);
        data_in = 16'h1234;
        #1;

        check_outputs(21'h0293A2);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hamming_encoder Testbench");
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
        input [20:0] expected_codeword_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_codeword_out === (expected_codeword_out ^ codeword_out ^ expected_codeword_out)) begin
                $display("PASS");
                $display("  Outputs: codeword_out=%h",
                         codeword_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: codeword_out=%h",
                         expected_codeword_out);
                $display("  Got:      codeword_out=%h",
                         codeword_out);
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
