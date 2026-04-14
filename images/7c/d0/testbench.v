`timescale 1ns/1ps

module register_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    reg [7:0] data_in;
    reg set;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_8bit dut (
        .clk(clk),
        .clr(clr),
        .data_in(data_in),
        .set(set),
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
            set = 0;
            clr = 1;
            data_in = 8'h00;
            @(posedge clk);
            #2;
            clr = 0;
            $display("DUT Reset to 0x00");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Normal Data Load (0xA5)", test_num);
            reset_dut();

            @(negedge clk);
            set = 0;
            clr = 0;
            data_in = 8'hA5;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Synchronous Clear", test_num);
            reset_dut();


            @(negedge clk);
            data_in = 8'hFF;
            @(posedge clk);


            @(negedge clk);
            clr = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Synchronous Set", test_num);
            reset_dut();

            @(negedge clk);
            set = 1;
            clr = 0;
            data_in = 8'h55;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Priority Check (Set and Clear active)", test_num);
            reset_dut();

            @(negedge clk);
            set = 1;
            clr = 1;
            data_in = 8'hAA;

            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Data Stability (Keep value)", test_num);
            reset_dut();


            @(negedge clk);
            data_in = 8'h3C;
            @(posedge clk);




            @(negedge clk);
            data_in = 8'hC3;
            set = 0;
            clr = 0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hC3);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Load 0x00 via data_in", test_num);
            reset_dut();


            @(negedge clk);
            set = 1;
            @(posedge clk);

            @(negedge clk);
            set = 0;
            clr = 0;
            data_in = 8'h00;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register_8bit Testbench");
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
        $dumpvars(0,clk, clr, data_in, set, data_out);
    end

endmodule
