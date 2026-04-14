`timescale 1ns/1ps

module sram_1bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data;
    reg we;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_1bit dut (
        .clk(clk),
        .data(data),
        .we(we),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we <= 1'b1;
            data <= 1'b0;
            @(posedge clk);
            #1;
            we <= 1'b0;
            data <= 1'bx;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Write 1 and Read 1", test_num);
            reset_dut();


            we <= 1'b1;
            data <= 1'b1;
            @(posedge clk);
            #1;


            we <= 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Write 0 and Read 0", test_num);
            reset_dut();


            we <= 1'b1;
            data <= 1'b1;
            @(posedge clk);
            #1;


            we <= 1'b1;
            data <= 1'b0;
            @(posedge clk);
            #1;


            we <= 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Write Enable Low (Data Retention)", test_num);
            reset_dut();


            we <= 1'b1;
            data <= 1'b1;
            @(posedge clk);
            #1;


            we <= 1'b0;
            data <= 1'b0;
            @(posedge clk);
            #1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Data stability over multiple cycles", test_num);
            reset_dut();


            we <= 1'b1;
            data <= 1'b1;
            @(posedge clk);
            #1;


            we <= 1'b0;
            repeat(5) begin
                data <= ~data;
                @(posedge clk);
                #1;
            end


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Back-to-back writes", test_num);
            reset_dut();


            we <= 1'b1;
            data <= 1'b1;
            @(posedge clk);
            #1;


            we <= 1'b1;
            data <= 1'b0;
            @(posedge clk);
            #1;


            we <= 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sram_1bit Testbench");
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
        input expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%b",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b",
                         expected_q);
                $display("  Got:      q=%b",
                         q);
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
        $dumpvars(0,clk, data, we, q);
    end

endmodule
