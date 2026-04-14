`timescale 1ns/1ps

module ram_128x64_sp_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] addr;
    reg clk;
    reg [63:0] wdata;
    reg we;
    wire [63:0] rdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ram_128x64_sp dut (
        .addr(addr),
        .clk(clk),
        .wdata(wdata),
        .we(we),
        .rdata(rdata)
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
            wdata = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read at Address 0", test_num);


            we = 1;
            addr = 7'h00;
            wdata = 64'h0123456789ABCDEF;
            @(posedge clk);


            #1;
            we = 0;
            addr = 7'h00;
            @(posedge clk);


            #2;
            #1;

            check_outputs(64'h0123456789ABCDEF);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Write and Read at Middle Address (64)", test_num);


            we = 1;
            addr = 7'd64;
            wdata = 64'hAAAA_BBBB_CCCC_DDDD;
            @(posedge clk);


            #1;
            we = 0;
            addr = 7'd64;
            @(posedge clk);

            #2;
            #1;

            check_outputs(64'hAAAA_BBBB_CCCC_DDDD);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Write and Read at Last Address (127)", test_num);


            we = 1;
            addr = 7'd127;
            wdata = 64'hFFFF_FFFF_FFFF_FFFF;
            @(posedge clk);


            #1;
            we = 0;
            addr = 7'd127;
            @(posedge clk);

            #2;
            #1;

            check_outputs(64'hFFFF_FFFF_FFFF_FFFF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Overwrite existing data", test_num);


            we = 1;
            addr = 7'd10;
            wdata = 64'h1111_1111_1111_1111;
            @(posedge clk);


            #1;
            we = 1;
            addr = 7'd10;
            wdata = 64'h2222_2222_2222_2222;
            @(posedge clk);


            #1;
            we = 0;
            addr = 7'd10;
            @(posedge clk);

            #2;
            #1;

            check_outputs(64'h2222_2222_2222_2222);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Data Persistence check", test_num);


            we = 1;
            addr = 7'd5;
            wdata = 64'h5555_5555_5555_5555;
            @(posedge clk);


            #1;
            we = 1;
            addr = 7'd6;
            wdata = 64'h6666_6666_6666_6666;
            @(posedge clk);


            #1;
            we = 0;
            addr = 7'd5;
            @(posedge clk);

            #2;
            #1;

            check_outputs(64'h5555_5555_5555_5555);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ram_128x64_sp Testbench");
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
        input [63:0] expected_rdata;
        begin
            if (expected_rdata === (expected_rdata ^ rdata ^ expected_rdata)) begin
                $display("PASS");
                $display("  Outputs: rdata=%h",
                         rdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rdata=%h",
                         expected_rdata);
                $display("  Got:      rdata=%h",
                         rdata);
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
        $dumpvars(0,addr, clk, wdata, we, rdata);
    end

endmodule
