`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] data_in;
    reg write_enable;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .data_in(data_in),
        .write_enable(write_enable),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        write_enable = 0;
        forever #5 write_enable = ~write_enable;
    end

        task reset_dut;

        begin
            data_in = 8'h00;

            @(negedge write_enable);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %03d: Basic Write/Read 0xAA", test_num);

            @(posedge write_enable);
            data_in = 8'hAA;
            @(negedge write_enable);
            #2;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %03d: Basic Write/Read 0x55", test_num);

            @(posedge write_enable);
            data_in = 8'h55;
            @(negedge write_enable);
            #2;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %03d: Data Retention Test", test_num);

            @(posedge write_enable);
            data_in = 8'hD3;
            @(negedge write_enable);
            data_in = 8'h00;
            #2;
            #1;

            check_outputs(8'hD3);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %03d: Write All Zeros", test_num);

            @(posedge write_enable);
            data_in = 8'h00;
            @(negedge write_enable);
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %03d: Write All Ones", test_num);

            @(posedge write_enable);
            data_in = 8'hFF;
            @(negedge write_enable);
            #2;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %03d: Overwrite Test", test_num);


            @(posedge write_enable);
            data_in = 8'h11;
            @(negedge write_enable);


            @(posedge write_enable);
            data_in = 8'h22;
            @(negedge write_enable);
            #2;
            #1;

            check_outputs(8'h22);
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
        $dumpvars(0,data_in, write_enable, data_out);
    end

endmodule
