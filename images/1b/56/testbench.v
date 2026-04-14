`timescale 1ns/1ps

module crc_generator_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data_in;
    wire [31:0] crc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    crc_generator dut (
        .data_in(data_in),
        .crc_out(crc_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros", test_num);

        data_in = 32'h0000_0000;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single Bit Set (LSB)", test_num);


        data_in = 32'h0000_0001;
        #1;

        check_outputs(32'h04C11DB7);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single Bit Set (MSB)", test_num);

        data_in = 32'h8000_0000;
        #1;

        check_outputs(32'h4002B413);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Ones", test_num);

        data_in = 32'hFFFF_FFFF;
        #1;

        check_outputs(32'h3291D659);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating Bits (Pattern A)", test_num);
        data_in = 32'hAAAA_AAAA;
        #1;

        check_outputs(32'h1E0D9099);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating Bits (Pattern 5)", test_num);
        data_in = 32'h5555_5555;
        #1;

        check_outputs(32'h3D70535B);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Hex Sequence 1-8", test_num);
        data_in = 32'h1234_5678;
        #1;

        check_outputs(32'hC9E64A7B);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Random Pattern (Dead Beef)", test_num);
        data_in = 32'hDEAD_BEEF;
        #1;

        check_outputs(32'hA2D16D41);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Walking Ones (Bit 16)", test_num);
        data_in = 32'h0001_0000;
        #1;

        check_outputs(32'h04C11DB7);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Prime-like bit distribution", test_num);
        data_in = 32'hBADC_0FFE;
        #1;

        check_outputs(32'h0F966B2F);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("crc_generator Testbench");
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
