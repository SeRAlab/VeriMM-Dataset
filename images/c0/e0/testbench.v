`timescale 1ns/1ps

module fasm_sparam_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] adr_i;
    reg clk_i;
    reg [1:0] dat_i;
    reg rst_i;
    reg stb_i;
    reg wre_i;
    wire [1:0] dat_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fasm_sparam dut (
        .adr_i(adr_i),
        .clk_i(clk_i),
        .dat_i(dat_i),
        .rst_i(rst_i),
        .stb_i(stb_i),
        .wre_i(wre_i),
        .dat_o(dat_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            adr_i = 0;
            dat_i = 0;
            wre_i = 0;
            stb_i = 0;
            rst_i = 1;
            #10;
            rst_i = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read Back", test_num);


            @(negedge clk_i);
            adr_i = 5'h0A;
            dat_i = 2'b11;
            wre_i = 1;
            stb_i = 1;


            @(posedge clk_i);
            #2;


            wre_i = 0;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Memory Locations", test_num);


            @(negedge clk_i);
            adr_i = 5'h05;
            dat_i = 2'b01;
            wre_i = 1;
            @(posedge clk_i);


            @(negedge clk_i);
            adr_i = 5'h1F;
            dat_i = 2'b10;
            wre_i = 1;
            @(posedge clk_i);

            #2;
            wre_i = 0;


            adr_i = 5'h05;
            #1;
            if (dat_o !== 2'b01) begin
                $display("Sub-test failed at addr 0x05");
                #1;

                check_outputs(2'b01);
            end else begin

                adr_i = 5'h1F;
                #1;
                #1;

                check_outputs(2'b10);
            end
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Write Enable (wre_i) Check", test_num);


            @(negedge clk_i);
            adr_i = 5'h10;
            dat_i = 2'b11;
            wre_i = 1;
            @(posedge clk_i);


            @(negedge clk_i);
            adr_i = 5'h10;
            dat_i = 2'b00;
            wre_i = 0;
            @(posedge clk_i);

            #2;

            #1;


            check_outputs(2'b11);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Overwriting Existing Value", test_num);


            @(negedge clk_i);
            adr_i = 5'h02;
            dat_i = 2'b01;
            wre_i = 1;
            @(posedge clk_i);


            @(negedge clk_i);
            dat_i = 2'b10;
            @(posedge clk_i);

            #2;
            wre_i = 0;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Address Switching (Combinational Read)", test_num);


            @(negedge clk_i);
            adr_i = 5'h01; dat_i = 2'b01; wre_i = 1;
            @(posedge clk_i);

            @(negedge clk_i);
            adr_i = 5'h02; dat_i = 2'b11; wre_i = 1;
            @(posedge clk_i);

            wre_i = 0;


            adr_i = 5'h01;
            #1;
            if (dat_o !== 2'b01) begin
                 #1;

                 check_outputs(2'b01);
            end else begin
                adr_i = 5'h02;
                #1;
                #1;

                check_outputs(2'b11);
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fasm_sparam Testbench");
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
        input [1:0] expected_dat_o;
        begin
            if (expected_dat_o === (expected_dat_o ^ dat_o ^ expected_dat_o)) begin
                $display("PASS");
                $display("  Outputs: dat_o=%h",
                         dat_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dat_o=%h",
                         expected_dat_o);
                $display("  Got:      dat_o=%h",
                         dat_o);
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
        $dumpvars(0,adr_i, clk_i, dat_i, rst_i, stb_i, wre_i, dat_o);
    end

endmodule
