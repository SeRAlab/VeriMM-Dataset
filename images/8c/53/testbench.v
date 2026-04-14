`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] address;
    reg clk;
    reg cs;
    reg csprng_error;
    reg reset_n;
    reg we;
    reg [31:0] write_data;
    wire csprng_debug_mode;
    wire [4:0] csprng_num_rounds;
    wire csprng_reseed;
    wire error;
    wire [31:0] read_data;
    wire security_error;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clk(clk),
        .cs(cs),
        .csprng_error(csprng_error),
        .reset_n(reset_n),
        .we(we),
        .write_data(write_data),
        .csprng_debug_mode(csprng_debug_mode),
        .csprng_num_rounds(csprng_num_rounds),
        .csprng_reseed(csprng_reseed),
        .error(error),
        .read_data(read_data),
        .security_error(security_error)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Power-on Reset State", test_num);
            reset_n = 0; address = 0; cs = 0; we = 0; write_data = 0; csprng_error = 0;
            repeat(2) @(posedge clk);
            reset_n = 1;
            @(posedge clk);

            #1;


            check_outputs(0, 5'h0, 0, 0, 32'h0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Read Core ID Name 0 (Addr 0x00)", test_num);
            reset_n = 0; #10; reset_n = 1; @(posedge clk);
            cs = 1; we = 0; address = 8'h00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 5'h0, 0, 0, 32'h74726e67, 0);
            cs = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Read Core ID Name 1 (Addr 0x01)", test_num);
            reset_n = 0; #10; reset_n = 1; @(posedge clk);
            cs = 1; we = 0; address = 8'h01;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 5'h0, 0, 0, 32'h6374726c, 0);
            cs = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Read Version (Addr 0x02)", test_num);
            reset_n = 0; #10; reset_n = 1; @(posedge clk);
            cs = 1; we = 0; address = 8'h02;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 5'h0, 0, 0, 32'h302e3130, 0);
            cs = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Write Control - Debug Mode Enable", test_num);
            reset_n = 0; #10; reset_n = 1; @(posedge clk);
            cs = 1; we = 1; address = 8'h10; write_data = 32'h0000_0001;
            @(posedge clk);
            we = 0;
            #2;
            #1;

            check_outputs(1, 5'h0, 0, 0, 32'h0, 0);
            cs = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Write Control - Set Num Rounds", test_num);
            reset_n = 0; #10; reset_n = 1; @(posedge clk);
            cs = 1; we = 1; address = 8'h10; write_data = (5'h1F << 3);
            @(posedge clk);
            we = 0;
            #2;
            #1;

            check_outputs(0, 5'h1F, 0, 0, 32'h0, 0);
            cs = 0;
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Pulse Reseed Bit", test_num);
            reset_n = 0; #10; reset_n = 1; @(posedge clk);
            cs = 1; we = 1; address = 8'h10; write_data = 32'h0000_0002;
            @(posedge clk);
            we = 0;
            #2;
            #1;

            check_outputs(0, 5'h0, 1, 0, 32'h0, 0);
            cs = 0;
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Invalid Address Error", test_num);
            reset_n = 0; #10; reset_n = 1; @(posedge clk);
            cs = 1; we = 0; address = 8'hFF;
            @(posedge clk);
            #2;

            #1;


            check_outputs(0, 5'h0, 0, 1, 32'h0, 0);
            cs = 0;
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Security Error Propagation", test_num);
            reset_n = 0; #10; reset_n = 1; @(posedge clk);
            csprng_error = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(0, 5'h0, 0, 0, 32'h0, 1);
            csprng_error = 0;
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
        input expected_csprng_debug_mode;
        input [4:0] expected_csprng_num_rounds;
        input expected_csprng_reseed;
        input expected_error;
        input [31:0] expected_read_data;
        input expected_security_error;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_csprng_debug_mode === (expected_csprng_debug_mode ^ csprng_debug_mode ^ expected_csprng_debug_mode) &&
                expected_csprng_num_rounds === (expected_csprng_num_rounds ^ csprng_num_rounds ^ expected_csprng_num_rounds) &&
                expected_csprng_reseed === (expected_csprng_reseed ^ csprng_reseed ^ expected_csprng_reseed) &&
                expected_error === (expected_error ^ error ^ expected_error) &&
                expected_read_data === (expected_read_data ^ read_data ^ expected_read_data) &&
                expected_security_error === (expected_security_error ^ security_error ^ expected_security_error)) begin
                $display("PASS");
                $display("  Outputs: csprng_debug_mode=%b, csprng_num_rounds=%h, csprng_reseed=%b, error=%b, read_data=%h, security_error=%b",
                         csprng_debug_mode, csprng_num_rounds, csprng_reseed, error, read_data, security_error);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: csprng_debug_mode=%b, csprng_num_rounds=%h, csprng_reseed=%b, error=%b, read_data=%h, security_error=%b",
                         expected_csprng_debug_mode, expected_csprng_num_rounds, expected_csprng_reseed, expected_error, expected_read_data, expected_security_error);
                $display("  Got:      csprng_debug_mode=%b, csprng_num_rounds=%h, csprng_reseed=%b, error=%b, read_data=%h, security_error=%b",
                         csprng_debug_mode, csprng_num_rounds, csprng_reseed, error, read_data, security_error);
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
