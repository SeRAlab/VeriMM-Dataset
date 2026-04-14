`timescale 1ns/1ps

module pipo_shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg load_en;
    reg shift_en;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipo_shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .load_en(load_en),
        .shift_en(shift_en),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            data_in = 8'h00;
            load_en = 1'b1;
            shift_en = 1'b0;
            @(negedge clk);
            load_en = 1'b0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Parallel Load - Loading 0xA5", test_num);
            reset_dut();

            @(negedge clk);
            data_in = 8'hA5;
            load_en = 1'b1;
            shift_en = 1'b0;

            @(negedge clk);
            load_en = 1'b0;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single Right Shift - 0x80 to 0x40", test_num);
            reset_dut();


            @(negedge clk);
            data_in = 8'h80;
            load_en = 1'b1;
            @(negedge clk);
            load_en = 1'b0;


            shift_en = 1'b1;
            @(negedge clk);
            shift_en = 1'b0;

            #1;


            check_outputs(8'h40);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple Right Shifts - 0xF0 to 0x0F", test_num);
            reset_dut();


            @(negedge clk);
            data_in = 8'hF0;
            load_en = 1'b1;
            @(negedge clk);
            load_en = 1'b0;


            shift_en = 1'b1;
            repeat(4) @(negedge clk);
            shift_en = 1'b0;

            #1;


            check_outputs(8'h0F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Hold Data - No Enables active", test_num);
            reset_dut();


            @(negedge clk);
            data_in = 8'h55;
            load_en = 1'b1;
            @(negedge clk);
            load_en = 1'b0;


            shift_en = 1'b0;
            data_in = 8'hFF;
            repeat(2) @(negedge clk);

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Full Shift Out - 0x01 to 0x00", test_num);
            reset_dut();


            @(negedge clk);
            data_in = 8'h01;
            load_en = 1'b1;
            @(negedge clk);
            load_en = 1'b0;


            shift_en = 1'b1;
            @(negedge clk);
            shift_en = 1'b0;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Priority Check - Load and Shift both high", test_num);
            reset_dut();


            @(negedge clk);
            data_in = 8'hAA;
            load_en = 1'b1;
            @(negedge clk);



            data_in = 8'hCC;
            load_en = 1'b1;
            shift_en = 1'b1;
            @(negedge clk);
            load_en = 1'b0;
            shift_en = 1'b0;



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
        $display("pipo_shift_register Testbench");
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
        $dumpvars(0,clk, data_in, load_en, shift_en, data_out);
    end

endmodule
