`timescale 1ns/1ps

module dr_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg re;
    reg we;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dr_cell dut (
        .clk(clk),
        .data_in(data_in),
        .re(re),
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
            re = 0;
            data_in = 8'h00;
            @(posedge clk);

            we = 1;
            data_in = 8'h00;
            @(posedge clk);
            we = 0;
            data_in = 8'h00;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Write and Read", test_num);
            reset_dut();


            @(negedge clk);
            we = 1;
            re = 0;
            data_in = 8'hA5;
            @(posedge clk);


            @(negedge clk);
            we = 0;
            re = 1;


            #2;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Data persistence without WE", test_num);
            reset_dut();


            @(negedge clk);
            we = 1;
            data_in = 8'h5A;
            @(posedge clk);


            @(negedge clk);
            we = 0;
            re = 0;
            data_in = 8'hFF;
            repeat(2) @(posedge clk);


            @(negedge clk);
            re = 1;
            #2;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Priority and Simultaneous R/W", test_num);
            reset_dut();


            @(negedge clk);
            we = 1;
            data_in = 8'h11;
            @(posedge clk);




            @(negedge clk);
            we = 1;
            re = 1;
            data_in = 8'h22;


            #2;
            if (data_out == 8'h11) begin
                $display("  Read priority verified: Output is old data 0x11");
            end

            @(posedge clk);


            @(negedge clk);
            we = 0;
            re = 1;
            #2;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Successive Writes", test_num);
            reset_dut();

            @(negedge clk);
            we = 1;
            data_in = 8'hCC;
            @(posedge clk);

            @(negedge clk);
            data_in = 8'hDD;
            @(posedge clk);

            @(negedge clk);
            we = 0;
            re = 1;
            #2;
            #1;

            check_outputs(8'hDD);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Read Enable Toggle", test_num);
            reset_dut();


            @(negedge clk);
            we = 1;
            data_in = 8'hEE;
            @(posedge clk);


            @(negedge clk);
            we = 0;
            re = 0;
            #2;


            re = 1;
            #2;
            #1;

            check_outputs(8'hEE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dr_cell Testbench");
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
        $dumpvars(0,clk, data_in, re, we, data_out);
    end

endmodule
