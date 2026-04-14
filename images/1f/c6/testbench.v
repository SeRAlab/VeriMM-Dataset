`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg write_enable;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .write_enable(write_enable),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            write_enable = 0;
            data_in = 8'h00;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Write and Read (0xA5)", test_num);
            reset_dut();


            data_in = 8'hA5;
            write_enable = 1;
            @(posedge clk);
            #2;


            write_enable = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Write all ones (0xFF)", test_num);
            reset_dut();

            data_in = 8'hFF;
            write_enable = 1;
            @(posedge clk);
            #2;

            write_enable = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Write Enable Low (Data should not be stored)", test_num);
            reset_dut();


            data_in = 8'h55;
            write_enable = 0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overwriting value (0x11 -> 0x22)", test_num);
            reset_dut();


            data_in = 8'h11;
            write_enable = 1;
            @(posedge clk);
            #2;


            data_in = 8'h22;
            write_enable = 1;
            @(posedge clk);
            #2;

            write_enable = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h22);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset clears stored data", test_num);
            reset_dut();


            data_in = 8'hEE;
            write_enable = 1;
            @(posedge clk);
            #2;
            write_enable = 0;


            reset = 1;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data stability over multiple cycles", test_num);
            reset_dut();


            data_in = 8'h3C;
            write_enable = 1;
            @(posedge clk);
            #2;


            write_enable = 0;
            data_in = 8'hZZ;
            repeat(5) @(posedge clk);
            #2;

            #1;


            check_outputs(8'h3C);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dram_cell Testbench");
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
        input [7:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, reset, write_enable, data_out);
    end

endmodule
