`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg write_en;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .clk(clk),
        .data_in(data_in),
        .write_en(write_en),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting/Initializing SRAM cell...");
            @(negedge clk);
            write_en = 1;
            data_in = 16'h0000;
            @(posedge clk);
            #1;
            write_en = 0;
            data_in = 16'hZZZZ;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read", test_num);
            reset_dut();

            @(negedge clk);
            write_en = 1;
            data_in = 16'hABCD;
            @(posedge clk);
            #1;
            write_en = 0;
            data_in = 16'h0000;

            #1;


            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Writing All Ones", test_num);
            reset_dut();

            @(negedge clk);
            write_en = 1;
            data_in = 16'hFFFF;
            @(posedge clk);
            #1;
            write_en = 0;

            #1;


            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying Write Enable Low", test_num);
            reset_dut();

            @(negedge clk);
            write_en = 0;
            data_in = 16'h55AA;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwriting existing data", test_num);
            reset_dut();

            @(negedge clk);
            write_en = 1;
            data_in = 16'h1111;
            @(posedge clk);
            #1;
            data_in = 16'h2222;
            @(posedge clk);
            #1;
            write_en = 0;

            #1;


            check_outputs(16'h2222);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Persistence", test_num);
            reset_dut();

            @(negedge clk);
            write_en = 1;
            data_in = 16'hE0E0;
            @(posedge clk);
            #1;
            write_en = 0;
            data_in = 16'h1234;


            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(16'hE0E0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bit Pattern", test_num);
            reset_dut();

            @(negedge clk);
            write_en = 1;
            data_in = 16'hAAAA;
            @(posedge clk);
            #1;
            write_en = 0;

            #1;


            check_outputs(16'hAAAA);
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
        input [15:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, write_en, data_out);
    end

endmodule
