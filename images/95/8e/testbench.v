`timescale 1ns/1ps

module preset_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [5:0] data_in;
    reg load;
    reg preset;
    reg [5:0] preset_value;
    wire [5:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    preset_register dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .preset(preset),
        .preset_value(preset_value),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            preset = 1;
            preset_value = 6'b0;
            load = 0;
            data_in = 6'b0;
            @(posedge clk);
            #1;
            preset = 0;
            preset_value = 6'b0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Synchronous Preset", test_num);
            reset_dut();

            preset = 1;
            preset_value = 6'h2A;
            load = 0;
            data_in = 6'h15;

            @(posedge clk);
            #1;
            #1;

            check_outputs(6'h2A);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Load functionality", test_num);
            reset_dut();

            preset = 0;
            load = 1;
            data_in = 6'h3F;

            @(posedge clk);
            #1;
            #1;

            check_outputs(6'h3F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Hold functionality", test_num);
            reset_dut();


            load = 1;
            data_in = 6'h0F;
            @(posedge clk);
            #1;


            load = 0;
            preset = 0;
            data_in = 6'h33;

            @(posedge clk);
            #1;
            #1;

            check_outputs(6'h0F);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Preset Priority", test_num);
            reset_dut();

            preset = 1;
            preset_value = 6'h05;
            load = 1;
            data_in = 6'h30;

            @(posedge clk);
            #1;
            #1;

            check_outputs(6'h05);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Load zero value", test_num);
            reset_dut();


            preset = 1;
            preset_value = 6'h3F;
            @(posedge clk);
            #1;


            preset = 0;
            load = 1;
            data_in = 6'h00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(6'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Rapid sequential loads", test_num);
            reset_dut();

            load = 1;
            data_in = 6'h11;
            @(posedge clk);
            #1;
            data_in = 6'h22;
            @(posedge clk);
            #1;
            data_in = 6'h33;
            @(posedge clk);
            #1;

            #1;


            check_outputs(6'h33);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("preset_register Testbench");
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
        input [5:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, load, preset, preset_value, data_out);
    end

endmodule
