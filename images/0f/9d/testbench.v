`timescale 1ns/1ps

module nat_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] external_ip;
    reg [31:0] internal_ip;
    reg [15:0] internal_port;
    reg rst;
    wire [15:0] external_port;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nat dut (
        .clk(clk),
        .external_ip(external_ip),
        .internal_ip(internal_ip),
        .internal_port(internal_port),
        .rst(rst),
        .external_port(external_port)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            internal_ip = 0;
            internal_port = 0;
            external_ip = 0;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Mapping Creation", test_num);
            reset_dut();

            internal_ip   = 32'hC0A80001;
            internal_port = 16'h1F40;
            external_ip   = 32'h08080808;

            @(posedge clk);
            #2;



            #1;




            check_outputs(16'd1024);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mapping Persistence", test_num);
            reset_dut();

            internal_ip   = 32'h0A000005;
            internal_port = 16'h0050;
            external_ip   = 32'h01010101;

            @(posedge clk);
            #2;

            @(posedge clk);
            #2;

            #1;


            check_outputs(16'd1024);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Distinct Entries", test_num);
            reset_dut();


            internal_ip   = 32'hC0A80001; internal_port = 16'h1111; external_ip = 32'h01010101;
            @(posedge clk); #2;


            internal_ip   = 32'hC0A80002; internal_port = 16'h2222; external_ip = 32'h02020202;
            @(posedge clk); #2;


            internal_ip   = 32'hC0A80003; internal_port = 16'h3333; external_ip = 32'h03030303;
            @(posedge clk); #2;

            #1;


            check_outputs(16'd1026);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Capacity and Retrieval", test_num);
            reset_dut();


            internal_ip = 32'hC0A80101; internal_port = 16'd10; external_ip = 32'hDEADC0DE; @(posedge clk); #2;
            internal_ip = 32'hC0A80102; internal_port = 16'd20; external_ip = 32'hDEADC0DE; @(posedge clk); #2;
            internal_ip = 32'hC0A80103; internal_port = 16'd30; external_ip = 32'hDEADC0DE; @(posedge clk); #2;
            internal_ip = 32'hC0A80104; internal_port = 16'd40; external_ip = 32'hDEADC0DE; @(posedge clk); #2;


            internal_ip = 32'hC0A80102; internal_port = 16'd20; external_ip = 32'hDEADC0DE;
            @(posedge clk);
            #2;

            #1;


            check_outputs(16'd1025);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Verification", test_num);


            reset_dut();
            internal_ip = 32'hC0A80101; internal_port = 16'd500; external_ip = 32'h04040404;
            @(posedge clk); #2;


            reset_dut();


            internal_ip = 32'h0A0A0A0A; internal_port = 16'd999; external_ip = 32'h08080808;
            @(posedge clk);
            #2;

            #1;


            check_outputs(16'd1024);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nat Testbench");
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
        input [15:0] expected_external_port;
        begin
            if (expected_external_port === (expected_external_port ^ external_port ^ expected_external_port)) begin
                $display("PASS");
                $display("  Outputs: external_port=%h",
                         external_port);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: external_port=%h",
                         expected_external_port);
                $display("  Got:      external_port=%h",
                         external_port);
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
        $dumpvars(0,clk, external_ip, internal_ip, internal_port, rst, external_port);
    end

endmodule
