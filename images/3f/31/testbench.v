`timescale 1ns/1ps

module eeprom_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg we;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eeprom_cell dut (
        .clk(clk),
        .data_in(data_in),
        .we(we),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            data_in = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read Operation", test_num);
            reset_dut();


            data_in = 8'hA5;
            we = 1;
            @(posedge clk);
            #1;


            we = 0;
            data_in = 8'h00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Retention with WE=0", test_num);
            reset_dut();


            data_in = 8'h5A;
            we = 1;
            @(posedge clk);
            #1;


            we = 0;
            data_in = 8'hFF;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwriting Existing Data", test_num);
            reset_dut();


            data_in = 8'h11;
            we = 1;
            @(posedge clk);
            #1;


            data_in = 8'h22;
            we = 1;
            @(posedge clk);
            #1;


            we = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h22);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Value Test (0xFF)", test_num);
            reset_dut();

            data_in = 8'hFF;
            we = 1;
            @(posedge clk);
            #1;

            we = 0;
            data_in = 8'h00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Value Test (0x00)", test_num);
            reset_dut();


            data_in = 8'hAA;
            we = 1;
            @(posedge clk);
            #1;


            data_in = 8'h00;
            we = 1;
            @(posedge clk);
            #1;

            we = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No Write When WE=0", test_num);
            reset_dut();


            data_in = 8'hCC;
            we = 1;
            @(posedge clk);
            #1;


            data_in = 8'hDD;
            we = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'hCC);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("eeprom_cell Testbench");
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
        $dumpvars(0,clk, data_in, we, data_out);
    end

endmodule
