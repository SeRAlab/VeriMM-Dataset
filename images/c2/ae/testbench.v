`timescale 1ns/1ps

module ram_4x8_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] addr;
    reg clk;
    reg [3:0] din;
    reg en;
    reg we;
    wire [3:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ram_4x8 dut (
        .addr(addr),
        .clk(clk),
        .din(din),
        .en(en),
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
            en = 0;
            we = 0;
            addr = 0;
            din = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Reading initial state at address 5", test_num);

            en = 1;
            we = 0;
            addr = 3'd5;

            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Write 0xA to address 2 and read back", test_num);


            en = 1;
            we = 1;
            addr = 3'd2;
            din = 4'hA;
            @(posedge clk);


            we = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Write different values to multiple addresses", test_num);

            en = 1;


            we = 1;
            addr = 3'd7;
            din = 4'h5;
            @(posedge clk);


            addr = 3'd0;
            din = 4'hC;
            @(posedge clk);


            we = 0;
            addr = 3'd7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Attempt write while en=0", test_num);

            en = 0;
            we = 1;
            addr = 3'd3;
            din = 4'hF;
            @(posedge clk);


            en = 1;
            we = 0;
            addr = 3'd3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Attempt write while we=0", test_num);

            en = 1;
            we = 0;
            addr = 3'd4;
            din = 4'h7;
            @(posedge clk);


            addr = 3'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Overwriting existing data", test_num);

            en = 1;
            we = 1;
            addr = 3'd1;
            din = 4'h3;
            @(posedge clk);

            din = 4'hE;
            @(posedge clk);

            we = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ram_4x8 Testbench");
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
        $dumpvars(0,addr, clk, din, en, we, dout);
    end

endmodule
