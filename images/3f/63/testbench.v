`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg din;
    reg ren;
    reg wen;
    wire dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .clk(clk),
        .din(din),
        .ren(ren),
        .wen(wen),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wen = 0;
            ren = 0;
            din = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write '1' and Read '1'", test_num);
            reset_dut();


            @(negedge clk);
            wen = 1;
            din = 1;
            ren = 0;
            @(negedge clk);
            wen = 0;


            ren = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write '0' and Read '0'", test_num);
            reset_dut();


            @(negedge clk);
            wen = 1; din = 1;
            @(negedge clk);


            wen = 1; din = 0;
            @(negedge clk);
            wen = 0;


            ren = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Verify wen=0 prevents writing", test_num);
            reset_dut();


            @(negedge clk);
            wen = 1; din = 0;
            @(negedge clk);


            wen = 0; din = 1;
            @(negedge clk);


            ren = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Data Persistence check", test_num);
            reset_dut();


            @(negedge clk);
            wen = 1; din = 1;
            @(negedge clk);
            wen = 0;


            repeat(3) @(posedge clk);


            @(negedge clk);
            ren = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Verify ren=1 is required for output", test_num);
            reset_dut();


            @(negedge clk);
            wen = 1; din = 1;
            @(negedge clk);
            wen = 0;


            ren = 0;
            @(posedge clk);
            #1;


            if (dout === 1'b0 || dout === 1'bz) begin
                 $display("PASS: dout did not show data when ren=0");
                 pass_count = pass_count + 1;
            end else begin
                 $display("FAIL: dout showed data even when ren=0");
                 fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Sequential Write/Read Toggling", test_num);
            reset_dut();


            @(negedge clk);
            wen = 1; din = 1;
            @(negedge clk);
            wen = 0; ren = 1;
            @(negedge clk);
            ren = 0; wen = 1; din = 0;
            @(negedge clk);
            wen = 0; ren = 1;

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
        $display("dram_cell Testbench");
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
        input expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%b",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%b",
                         expected_dout);
                $display("  Got:      dout=%b",
                         dout);
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
        $dumpvars(0,clk, din, ren, wen, dout);
    end

endmodule
