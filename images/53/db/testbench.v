`timescale 1ns/1ps

module ram_4x16_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr;
    reg clk;
    reg [3:0] din;
    reg we;
    wire [3:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ram_4x16 dut (
        .addr(addr),
        .clk(clk),
        .din(din),
        .we(we),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            addr = 0;
            din = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Basic Write and Read", test_num);


            we = 1;
            addr = 4'h5;
            din = 4'hA;
            @(posedge clk);
            #2;
            we = 0;


            #1;



            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Write Enable Check", test_num);


            we = 1;
            addr = 4'h2;
            din = 4'h7;
            @(posedge clk);
            #2;


            we = 0;
            addr = 4'h2;
            din = 4'hF;
            @(posedge clk);
            #2;


            #1;



            check_outputs(4'h7);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Asynchronous Read Verification", test_num);


            we = 1; addr = 4'h8; din = 4'hC;
            @(posedge clk); #2;


            we = 1; addr = 4'h9; din = 4'hD;
            @(posedge clk); #2;

            we = 0;

            addr = 4'h8;
            #1;
            if (dout !== 4'hC) begin
                $display("Asynch Read Phase 1 Failed");
            end

            addr = 4'h9;
            #1;
            #1;

            check_outputs(4'hD);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Boundary Address Check", test_num);


            we = 1; addr = 4'h0; din = 4'h1;
            @(posedge clk); #2;


            we = 1; addr = 4'hF; din = 4'hE;
            @(posedge clk); #2;

            we = 0;
            addr = 4'hF;
            #1;
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Data Overwrite Check", test_num);


            we = 1; addr = 4'h4; din = 4'h1;
            @(posedge clk); #2;


            we = 1; addr = 4'h4; din = 4'h9;
            @(posedge clk); #2;

            we = 0;
            #1;
            #1;

            check_outputs(4'h9);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ram_4x16 Testbench");
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
        input [3:0] expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
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
        $dumpvars(0,addr, clk, din, we, dout);
    end

endmodule
