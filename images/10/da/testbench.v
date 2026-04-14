`timescale 1ns/1ps

module shift_register_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg load;
    reg shift_dir;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_16bit dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .shift_dir(shift_dir),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            load = 1;
            data_in = 16'h0000;
            shift_dir = 0;
            @(posedge clk);
            #1;
            load = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Parallel Load 0xABCD", test_num);

            load = 1;
            data_in = 16'hABCD;
            @(posedge clk);
            #1;
            load = 0;

            #1;


            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Left Shift (0x0001 -> 0x0002)", test_num);


            load = 1;
            data_in = 16'h0001;
            @(posedge clk);
            #1;


            load = 0;
            shift_dir = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0002);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Right Shift (0x8000 -> 0x4000)", test_num);


            load = 1;
            data_in = 16'h8000;
            @(posedge clk);
            #1;


            load = 0;
            shift_dir = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h4000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Left Shifts (4 cycles)", test_num);

            load = 1;
            data_in = 16'h000F;
            @(posedge clk);
            #1;

            load = 0;
            shift_dir = 0;
            repeat(4) @(posedge clk);
            #1;


            #1;



            check_outputs(16'h00F0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Right Shifts (8 cycles)", test_num);

            load = 1;
            data_in = 16'hFF00;
            @(posedge clk);
            #1;

            load = 0;
            shift_dir = 1;
            repeat(8) @(posedge clk);
            #1;


            #1;



            check_outputs(16'h00FF);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Load Priority Test", test_num);


            load = 1;
            data_in = 16'hAAAA;
            @(posedge clk);
            #1;


            load = 1;
            data_in = 16'h5555;
            shift_dir = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h5555);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Shift bit out (Left)", test_num);

            load = 1;
            data_in = 16'h8000;
            @(posedge clk);
            #1;

            load = 0;
            shift_dir = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h0000);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Direction Toggle Mid-process", test_num);

            load = 1;
            data_in = 16'h0010;
            @(posedge clk);
            #1;

            load = 0;
            shift_dir = 0;
            repeat(2) @(posedge clk);

            #1;
            shift_dir = 1;
            repeat(1) @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0020);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register_16bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        $dumpvars(0,clk, data_in, load, shift_dir, data_out);
    end

endmodule
