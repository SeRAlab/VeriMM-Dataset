`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] address;
    reg [15:0] data_in;
    reg write_enable;
    wire [15:0] data_out;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .address(address),
        .data_in(data_in),
        .write_enable(write_enable),
        .data_out(data_out),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        write_enable = 0;
        forever #5 write_enable = ~write_enable;
    end

        task reset_dut;

        begin
            address = 0;
            data_in = 0;

            #20;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Basic Write and Read at Address 0", test_num);


            address = 4'h0;
            data_in = 16'hABCD;


            @(posedge write_enable);
            @(negedge write_enable);
            #2;

            #1;


            check_outputs(16'hABCD, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Boundary Test at Address 15", test_num);

            address = 4'hF;
            data_in = 16'h55AA;

            @(posedge write_enable);
            @(negedge write_enable);
            #2;

            #1;


            check_outputs(16'h55AA, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Overwrite existing data at Address 7", test_num);


            address = 4'h7;
            data_in = 16'h1111;
            @(posedge write_enable);
            @(negedge write_enable);


            data_in = 16'hFFFF;
            @(posedge write_enable);
            @(negedge write_enable);
            #2;

            #1;


            check_outputs(16'hFFFF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Data Integrity across multiple addresses", test_num);


            address = 4'h2; data_in = 16'h2222;
            @(posedge write_enable);


            @(negedge write_enable);
            address = 4'h3; data_in = 16'h3333;
            @(posedge write_enable);


            @(negedge write_enable);
            address = 4'h2;
            #2;

            #1;


            check_outputs(16'h2222, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Zero pattern test at Address 10", test_num);

            address = 4'hA;
            data_in = 16'h0000;

            @(posedge write_enable);
            @(negedge write_enable);
            #2;

            #1;


            check_outputs(16'h0000, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sram_cell Testbench");
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
        input [15:0] expected_data_out;
        input expected_ready;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, ready=%b",
                         data_out, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, ready=%b",
                         expected_data_out, expected_ready);
                $display("  Got:      data_out=%h, ready=%b",
                         data_out, ready);
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
        $dumpvars(0,address, data_in, write_enable, data_out, ready);
    end

endmodule
