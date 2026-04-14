`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg [2:0] pin_num;
    reg rst;
    reg write_enable;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .data_in(data_in),
        .pin_num(pin_num),
        .rst(rst),
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
            rst = 1;
            data_in = 0;
            pin_num = 0;
            write_enable = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Write 0xA to Pin 0 and Read back", test_num);


            @(negedge clk);
            pin_num = 3'd0;
            data_in = 4'hA;
            write_enable = 1;
            @(posedge clk);


            #1;
            write_enable = 0;
            pin_num = 3'd0;
            #1;

            #1;


            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Write 0x5 to Pin 7 and Read back", test_num);

            @(negedge clk);
            pin_num = 3'd7;
            data_in = 4'h5;
            write_enable = 1;
            @(posedge clk);

            #1;
            write_enable = 0;
            pin_num = 3'd7;
            #1;

            #1;


            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Verify Pin 4 is 0 after Reset", test_num);

            @(negedge clk);
            write_enable = 0;
            pin_num = 3'd4;
            #1;

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Overwrite Pin 2 (0x3 -> 0xF)", test_num);


            @(negedge clk);
            pin_num = 3'd2;
            data_in = 4'h3;
            write_enable = 1;
            @(posedge clk);


            @(negedge clk);
            data_in = 4'hF;
            @(posedge clk);

            #1;
            write_enable = 0;
            pin_num = 3'd2;
            #1;

            #1;


            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Attempt write to Pin 1 with write_enable=0", test_num);


            @(negedge clk);
            pin_num = 3'd1;
            data_in = 4'hC;
            write_enable = 1;
            @(posedge clk);


            @(negedge clk);
            data_in = 4'h0;
            write_enable = 0;
            @(posedge clk);

            #1;
            pin_num = 3'd1;
            #1;


            #1;



            check_outputs(4'hC);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Write Pin 5, then Pin 6, Read Pin 5 to ensure no interference", test_num);


            @(negedge clk);
            pin_num = 3'd5;
            data_in = 4'hB;
            write_enable = 1;
            @(posedge clk);


            @(negedge clk);
            pin_num = 3'd6;
            data_in = 4'h1;
            @(posedge clk);

            #1;
            write_enable = 0;
            pin_num = 3'd5;
            #1;

            #1;


            check_outputs(4'hB);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gpio_controller Testbench");
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
        input [3:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, pin_num, rst, write_enable, data_out);
    end

endmodule
