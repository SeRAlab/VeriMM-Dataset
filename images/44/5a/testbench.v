`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] address;
    reg clk;
    reg [31:0] data;
    reg [31:0] ins;
    reg [4:0] ins_address;
    reg we;
    reg write_ins;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clk(clk),
        .data(data),
        .ins(ins),
        .ins_address(ins_address),
        .we(we),
        .write_ins(write_ins),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            address = 0;
            data = 0;
            we = 0;
            ins = 0;
            ins_address = 0;
            write_ins = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read", test_num);
            reset_dut();


            address = 5;
            data = 32'hABCDE123;
            we = 1;
            @(posedge clk);
            #1;
            we = 0;


            address = 5;
            #2;
            #1;

            check_outputs(32'hABCDE123);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Write Enable", test_num);
            reset_dut();


            address = 10;
            data = 32'hFFFFFFFF;
            we = 0;
            @(posedge clk);
            #1;


            address = 10;
            #2;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Consecutive Writes", test_num);
            reset_dut();


            address = 1;
            data = 32'h11111111;
            we = 1;
            @(posedge clk);
            #1;


            address = 2;
            data = 32'h22222222;
            we = 1;
            @(posedge clk);
            #1;
            we = 0;


            address = 2;
            #2;
            #1;

            check_outputs(32'h22222222);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwriting Data", test_num);
            reset_dut();


            address = 15;
            data = 32'hAAAA_AAAA;
            we = 1;
            @(posedge clk);
            #1;


            data = 32'h5555_5555;
            @(posedge clk);
            #1;
            we = 0;


            address = 15;
            #2;
            #1;

            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Instruction Storage Separation", test_num);
            reset_dut();


            address = 20;
            data = 32'hDADA_DADA;
            we = 1;
            @(posedge clk);
            #1;
            we = 0;


            ins_address = 20;
            ins = 32'h1122_3344;
            write_ins = 1;
            @(posedge clk);
            #1;
            write_ins = 0;


            address = 20;
            #2;
            #1;

            check_outputs(32'hDADA_DADA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Address 31", test_num);
            reset_dut();

            address = 31;
            data = 32'hE000_000E;
            we = 1;
            @(posedge clk);
            #1;
            we = 0;

            address = 31;
            #2;
            #1;

            check_outputs(32'hE000_000E);
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
        input [31:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,address, clk, data, ins, ins_address, we, write_ins, data_out);
    end

endmodule
