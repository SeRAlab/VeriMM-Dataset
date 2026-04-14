`timescale 1ns/1ps

module CacheFIFO_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] address;
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg write_enable;
    wire [7:0] data_out;
    wire hit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    CacheFIFO dut (
        .address(address),
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .write_enable(write_enable),
        .data_out(data_out),
        .hit(hit)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        address = 0;
        data_in = 0;
        write_enable = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task write_cycle;

        input [7:0] addr;
        input [7:0] data;
        begin
            @(posedge clk);
            address = addr;
            data_in = data;
            write_enable = 1;
            @(posedge clk);
            write_enable = 0;
            address = 0;
            data_in = 0;
            #1;
        end
        endtask

    task read_setup;

        input [7:0] addr;
        begin
            @(posedge clk);
            address = addr;
            write_enable = 0;
            #2;
        end
        endtask

    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Cold Miss Check", test_num);
        reset_dut();
        read_setup(8'hA0);
        #1;

        check_outputs(8'h00, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Write and Read Hit", test_num);
        reset_dut();
        write_cycle(8'h10, 8'hAA);
        read_setup(8'h10);
        #1;

        check_outputs(8'hAA, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Capacity Check (4 blocks)", test_num);
        reset_dut();
        write_cycle(8'h01, 8'h11);
        write_cycle(8'h02, 8'h22);
        write_cycle(8'h03, 8'h33);
        write_cycle(8'h04, 8'h44);
        read_setup(8'h01);
        #1;

        check_outputs(8'h11, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: FIFO Eviction (Oldest Block)", test_num);
        reset_dut();
        write_cycle(8'h01, 8'h11);
        write_cycle(8'h02, 8'h22);
        write_cycle(8'h03, 8'h33);
        write_cycle(8'h04, 8'h44);
        write_cycle(8'h05, 8'h55);
        read_setup(8'h01);
        #1;

        check_outputs(8'h00, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: FIFO Eviction (Survivor Check)", test_num);
        reset_dut();
        write_cycle(8'h01, 8'h11);
        write_cycle(8'h02, 8'h22);
        write_cycle(8'h03, 8'h33);
        write_cycle(8'h04, 8'h44);
        write_cycle(8'h05, 8'h55);
        read_setup(8'h02);
        #1;

        check_outputs(8'h22, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Update Existing Address", test_num);
        reset_dut();
        write_cycle(8'h10, 8'hAA);
        write_cycle(8'h10, 8'hBB);
        read_setup(8'h10);
        #1;

        check_outputs(8'hBB, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Full Cache Replacement", test_num);
        reset_dut();

        write_cycle(8'h01, 8'h11);
        write_cycle(8'h02, 8'h22);
        write_cycle(8'h03, 8'h33);
        write_cycle(8'h04, 8'h44);

        write_cycle(8'h05, 8'h55);
        write_cycle(8'h06, 8'h66);
        write_cycle(8'h07, 8'h77);
        write_cycle(8'h08, 8'h88);
        read_setup(8'h04);
        #1;

        check_outputs(8'h00, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("CacheFIFO Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [7:0] expected_data_out;
        input expected_hit;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_hit === (expected_hit ^ hit ^ expected_hit)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, hit=%b",
                         data_out, hit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, hit=%b",
                         expected_data_out, expected_hit);
                $display("  Got:      data_out=%h, hit=%b",
                         data_out, hit);
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
        $dumpvars(0,address, clk, data_in, reset, write_enable, data_out, hit);
    end

endmodule
