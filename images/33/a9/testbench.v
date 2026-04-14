`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dest_addr;
    reg enable;
    reg reset;
    reg rw;
    reg [7:0] src_addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .dest_addr(dest_addr),
        .enable(enable),
        .reset(reset),
        .rw(rw),
        .src_addr(src_addr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            rw = 0;
            src_addr = 8'h00;
            dest_addr = 8'h00;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            expected_done = 0;
            #1;

            check_outputs();
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            src_addr = 8'h0A;
            dest_addr = 8'h50;
            rw = 0;
            enable = 1;


            repeat(2) @(posedge clk);

            expected_done = 1;
            #1;

            check_outputs();
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            src_addr = 8'hFF;
            dest_addr = 8'hAA;
            rw = 1;
            enable = 1;

            repeat(2) @(posedge clk);

            expected_done = 1;
            #1;

            check_outputs();
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            src_addr = 8'h11;
            dest_addr = 8'h22;
            rw = 0;
            enable = 0;

            repeat(3) @(posedge clk);

            expected_done = 0;
            #1;

            check_outputs();
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            src_addr = 8'hCC;
            dest_addr = 8'hDD;
            enable = 1;
            @(posedge clk);
            enable = 0;

            repeat(2) @(posedge clk);



            expected_done = 1;
            #1;

            check_outputs();
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
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
        begin
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
        $dumpvars(0,clk, dest_addr, enable, reset, rw, src_addr);
    end

endmodule
