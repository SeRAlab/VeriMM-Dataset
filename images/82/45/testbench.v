`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] address;
    reg clk;
    reg cs;
    reg reset_n;
    reg we;
    reg [31:0] write_data;
    wire error;
    wire [31:0] read_data;
    wire ready;
    wire warning;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clk(clk),
        .cs(cs),
        .reset_n(reset_n),
        .we(we),
        .write_data(write_data),
        .error(error),
        .read_data(read_data),
        .ready(ready),
        .warning(warning)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset Behavior", test_num);
            reset_n = 0;
            cs = 0;
            we = 0;
            address = 0;
            write_data = 0;
            repeat(2) @(posedge clk);
            #1 reset_n = 1;
            repeat(1) @(posedge clk);

            #1;


            check_outputs(1'b0, 32'h0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Read Core Name (Addr 0x00)", test_num);
            reset_n = 0; #5 reset_n = 1;
            @(posedge clk);
            address = 8'h00;
            cs = 1;
            we = 0;
            @(posedge clk);

            #1;


            check_outputs(1'b0, 32'h434f5245, 1'b1, 1'b0);
            cs = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Read Version (Addr 0x01)", test_num);
            reset_n = 0; #5 reset_n = 1;
            @(posedge clk);
            address = 8'h01;
            cs = 1;
            we = 0;
            @(posedge clk);

            #1;


            check_outputs(1'b0, 32'h00000100, 1'b1, 1'b0);
            cs = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Write/Read Config Reg (Addr 0x10)", test_num);
            reset_n = 0; #5 reset_n = 1;
            @(posedge clk);


            address = 8'h10;
            write_data = 32'hDEADBEEF;
            cs = 1;
            we = 1;
            @(posedge clk);


            we = 0;
            @(posedge clk);
            #1;

            check_outputs(1'b0, 32'hDEADBEEF, 1'b1, 1'b0);
            cs = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Chip Select (cs) Isolation", test_num);
            reset_n = 0; #5 reset_n = 1;
            @(posedge clk);


            address = 8'h20;
            write_data = 32'hAABBCCDD;
            cs = 0;
            we = 1;
            @(posedge clk);


            we = 0;
            cs = 1;
            @(posedge clk);

            #1;


            check_outputs(1'b0, 32'h00000000, 1'b1, 1'b0);
            cs = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Write Enable (we) Isolation", test_num);
            reset_n = 0; #5 reset_n = 1;
            @(posedge clk);


            address = 8'h30;
            write_data = 32'h12345678;
            cs = 1;
            we = 0;
            @(posedge clk);


            @(posedge clk);
            #1;

            check_outputs(1'b0, 32'h00000000, 1'b1, 1'b0);
            cs = 0;
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
        input expected_error;
        input [31:0] expected_read_data;
        input expected_ready;
        input expected_warning;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_error === (expected_error ^ error ^ expected_error) &&
                expected_read_data === (expected_read_data ^ read_data ^ expected_read_data) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready) &&
                expected_warning === (expected_warning ^ warning ^ expected_warning)) begin
                $display("PASS");
                $display("  Outputs: error=%b, read_data=%h, ready=%b, warning=%b",
                         error, read_data, ready, warning);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: error=%b, read_data=%h, ready=%b, warning=%b",
                         expected_error, expected_read_data, expected_ready, expected_warning);
                $display("  Got:      error=%b, read_data=%h, ready=%b, warning=%b",
                         error, read_data, ready, warning);
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
