`timescale 1ns/1ps

module SRAM_8bit_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] data_in;
    reg read;
    reg we;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_8bit dut (
        .data_in(data_in),
        .read(read),
        .we(we),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        read = 0;
        forever #5 read = ~read;
    end

        task reset_dut;

        begin
            data_in = 8'h00;
            we = 0;

            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Basic Write and Read (8'hAA)", test_num);


            data_in = 8'hAA;
            we = 1;
            #10;


            we = 0;
            #10;



            wait(read === 1);
            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Overwrite Data (8'h55)", test_num);


            data_in = 8'hAA;
            we = 1;
            #10;


            data_in = 8'h55;
            we = 1;
            #10;

            we = 0;
            #10;

            wait(read === 1);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Write Enable check (No write when WE=0)", test_num);


            data_in = 8'hF0;
            we = 1;
            #10;


            data_in = 8'h0F;
            we = 0;
            #10;

            wait(read === 1);
            #1;
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Boundary Value (8'hFF)", test_num);

            data_in = 8'hFF;
            we = 1;
            #10;

            we = 0;
            #10;

            wait(read === 1);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Boundary Value (8'h00)", test_num);


            data_in = 8'hCC;
            we = 1;
            #10;

            data_in = 8'h00;
            we = 1;
            #10;

            we = 0;
            #10;

            wait(read === 1);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Data retention over multiple read cycles", test_num);

            data_in = 8'h3C;
            we = 1;
            #10;

            we = 0;
            data_in = 8'h00;


            #40;

            wait(read === 1);
            #1;
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
        $display("SRAM_8bit Testbench");
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
        $dumpvars(0,data_in, read, we, data_out);
    end

endmodule
