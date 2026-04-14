`timescale 1ns/1ps

module NAT_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg control;
    reg [31:0] internal_ip;
    wire [31:0] external_ip;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    NAT dut (
        .clk(clk),
        .control(control),
        .internal_ip(internal_ip),
        .external_ip(external_ip)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            control = 0;
            internal_ip = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Valid Translation 1", test_num);

            internal_ip = 32'hC0A80101;
            control = 1;

            @(posedge clk);
            #2;



            #1;




            check_outputs(32'hCB007101);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Valid Translation 2", test_num);

            internal_ip = 32'hC0A80102;
            control = 1;

            @(posedge clk);
            #2;


            #1;



            check_outputs(32'hCB007102);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: No Mapping (Default Output)", test_num);

            internal_ip = 32'h0A000001;
            control = 1;

            @(posedge clk);
            #2;


            #1;



            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Control Signal Low", test_num);


            internal_ip = 32'hC0A80101;
            control = 1;
            @(posedge clk);
            #2;


            internal_ip = 32'hC0A80102;
            control = 0;

            @(posedge clk);
            #2;



            #1;




            check_outputs(32'hCB007101);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Control High for one cycle", test_num);

            internal_ip = 32'hC0A80102;
            control = 1;
            @(posedge clk);
            #1;
            control = 0;

            @(posedge clk);
            #2;


            #1;



            check_outputs(32'hCB007102);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("NAT Testbench");
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
        input [31:0] expected_external_ip;
        begin
            if (expected_external_ip === (expected_external_ip ^ external_ip ^ expected_external_ip)) begin
                $display("PASS");
                $display("  Outputs: external_ip=%h",
                         external_ip);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: external_ip=%h",
                         expected_external_ip);
                $display("  Got:      external_ip=%h",
                         external_ip);
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
        $dumpvars(0,clk, control, internal_ip, external_ip);
    end

endmodule
