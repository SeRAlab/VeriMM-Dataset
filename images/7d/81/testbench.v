`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] address;
    reg [127:0] out_data;
    reg read;
    wire [127:0] data;
    wire [31:0] out_address;
    wire out_read;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .out_data(out_data),
        .read(read),
        .data(data),
        .out_address(out_address),
        .out_read(out_read)
    );

    // Clock generation (10ns period)
    initial begin
        read = 0;
        forever #5 read = ~read;
    end

        task reset_dut;

    begin
        address = 32'h0;
        out_data = 128'h0;


        repeat(5) @(posedge read);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Cold Start Miss (Address 0x1000)", test_num);
        reset_dut();
        address = 32'h0000_1000;
        out_data = 128'hA1A1A1A1_B2B2B2B2_C3C3C3C3_D4D4D4D4;
        repeat(2) @(posedge read);

        #1;


        check_outputs(128'hA1A1A1A1_B2B2B2B2_C3C3C3C3_D4D4D4D4, 32'h0000_1000, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Cache Hit (Address 0x1000)", test_num);
        reset_dut();

        address = 32'h0000_1000;
        out_data = 128'hA1A1A1A1_B2B2B2B2_C3C3C3C3_D4D4D4D4;
        repeat(5) @(posedge read);

        address = 32'h0000_1000;
        repeat(2) @(posedge read);

        #1;


        check_outputs(128'hA1A1A1A1_B2B2B2B2_C3C3C3C3_D4D4D4D4, 32'h0000_1000, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Different Address Miss (Address 0x2000)", test_num);
        reset_dut();

        address = 32'h0000_1000;
        out_data = 128'hA1A1A1A1_B2B2B2B2_C3C3C3C3_D4D4D4D4;
        repeat(5) @(posedge read);

        address = 32'h0000_2000;
        out_data = 128'h55555555_66666666_77777777_88888888;
        repeat(2) @(posedge read);

        #1;


        check_outputs(128'h55555555_66666666_77777777_88888888, 32'h0000_2000, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Consecutive Hit Check (Address 0x2000)", test_num);
        reset_dut();

        address = 32'h0000_2000;
        out_data = 128'h55555555_66666666_77777777_88888888;
        repeat(5) @(posedge read);

        address = 32'h0000_2000;
        repeat(5) @(posedge read);

        address = 32'h0000_2000;
        repeat(2) @(posedge read);
        #1;

        check_outputs(128'h55555555_66666666_77777777_88888888, 32'h0000_2000, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Boundary Address Miss (Address 0xFFFFFFFC)", test_num);
        reset_dut();
        address = 32'hFFFFFFFC;
        out_data = 128'hDEADBEEF_CAFED00D_00000000_FFFFFFFF;
        repeat(2) @(posedge read);
        #1;

        check_outputs(128'hDEADBEEF_CAFED00D_00000000_FFFFFFFF, 32'hFFFFFFFC, 1'b1);
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
        input [127:0] expected_data;
        input [31:0] expected_out_address;
        input expected_out_read;
        begin
            if (expected_data === (expected_data ^ data ^ expected_data) &&
                expected_out_address === (expected_out_address ^ out_address ^ expected_out_address) &&
                expected_out_read === (expected_out_read ^ out_read ^ expected_out_read)) begin
                $display("PASS");
                $display("  Outputs: data=%h, out_address=%h, out_read=%b",
                         data, out_address, out_read);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h, out_address=%h, out_read=%b",
                         expected_data, expected_out_address, expected_out_read);
                $display("  Got:      data=%h, out_address=%h, out_read=%b",
                         data, out_address, out_read);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,address, out_data, read, data, out_address, out_read);
    end

endmodule
