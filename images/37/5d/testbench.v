`timescale 1ns/1ps

module chacha20_simple_tb;

    // Testbench signals (combinational circuit)
    reg [255:0] key;
    reg [63:0] nonce;
    wire [31:0] output_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    chacha20_simple dut (
        .key(key),
        .nonce(nonce),
        .output_value(output_value)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: All Zeros", test_num);
        key = 256'h0;
        nonce = 64'h0;

        #1;


        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Key bit 0 set", test_num);
        key = 256'h1;
        nonce = 64'h0;

        #1;


        check_outputs(32'h00000080);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Nonce bit 0 set", test_num);
        key = 256'h0;
        nonce = 64'h1;

        #1;


        check_outputs(32'h00000080);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Bit rotation wrap-around", test_num);
        key = 256'h80000000;
        nonce = 64'h0;


        #1;



        check_outputs(32'h00000040);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Addition overflow", test_num);
        key = 256'hFFFFFFFF;
        nonce = 64'h1;


        #1;



        check_outputs(32'h00000000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Complex bit pattern", test_num);
        key = 256'h12345678;
        nonce = 64'h0;




        #1;





        check_outputs(32'h91A2B409);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Check if high nonce bits are ignored/used", test_num);
        key = 256'h0;
        nonce = 64'hFFFFFFFF00000000;

        #1;


        check_outputs(32'h00000000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Check if high key bits are ignored/used", test_num);
        key = 256'hFFFFFFFF00000000000000000000000000000000000000000000000000000000;
        nonce = 64'h0;

        #1;


        check_outputs(32'h00000000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("chacha20_simple Testbench");
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
        input [31:0] expected_output_value;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_value === (expected_output_value ^ output_value ^ expected_output_value)) begin
                $display("PASS");
                $display("  Outputs: output_value=%h",
                         output_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_value=%h",
                         expected_output_value);
                $display("  Got:      output_value=%h",
                         output_value);
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
