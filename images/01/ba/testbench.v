`timescale 1ns/1ps

module sram_16bit_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr;
    reg clk;
    reg [15:0] d;
    reg we;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_16bit dut (
        .addr(addr),
        .clk(clk),
        .d(d),
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
            we <= 0;
            addr <= 0;
            d <= 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Basic Write and Read at address 0", test_num);


            we <= 1;
            addr <= 4'h0;
            d <= 16'hABCD;
            @(posedge clk);


            #1;
            we <= 0;
            addr <= 4'h0;
            #2;

            #1;


            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Write and Read at address 15", test_num);


            we <= 1;
            addr <= 4'hF;
            d <= 16'h5555;
            @(posedge clk);


            #1;
            we <= 0;
            addr <= 4'hF;
            #2;

            #1;


            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Verify no write when WE is low", test_num);


            we <= 1;
            addr <= 4'h5;
            d <= 16'h1111;
            @(posedge clk);


            #1;
            we <= 0;
            addr <= 4'h5;
            d <= 16'hEEEE;
            @(posedge clk);


            #1;
            addr <= 4'h5;
            #2;

            #1;


            check_outputs(16'h1111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Sequential writes to multiple addresses", test_num);


            we <= 1; addr <= 4'h2; d <= 16'h2222;
            @(posedge clk);


            #1; we <= 1; addr <= 4'h7; d <= 16'h7777;
            @(posedge clk);


            #1; we <= 0; addr <= 4'h2;
            #2;
            if (q !== 16'h2222) begin
                #1;

                check_outputs(16'h2222);
            end else begin

                addr <= 4'h7;
                #2;
                #1;

                check_outputs(16'h7777);
            end
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Overwriting data at address 0xA", test_num);


            we <= 1;
            addr <= 4'hA;
            d <= 16'hAAAA;
            @(posedge clk);


            #1;
            we <= 1;
            addr <= 4'hA;
            d <= 16'hBBBB;
            @(posedge clk);


            #1;
            we <= 0;
            addr <= 4'hA;
            #2;

            #1;


            check_outputs(16'hBBBB);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sram_16bit Testbench");
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
        input [15:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
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
        $dumpvars(0,addr, clk, d, we, q);
    end

endmodule
